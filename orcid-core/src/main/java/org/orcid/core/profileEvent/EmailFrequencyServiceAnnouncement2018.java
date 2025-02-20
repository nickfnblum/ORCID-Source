package org.orcid.core.profileEvent;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.commons.lang3.LocaleUtils;
import org.apache.commons.lang3.time.DurationFormatUtils;
import org.kohsuke.args4j.CmdLineException;
import org.kohsuke.args4j.CmdLineParser;
import org.kohsuke.args4j.Option;
import org.orcid.core.manager.TemplateManager;
import org.orcid.core.manager.impl.OrcidUrlManager;
import org.orcid.core.manager.v3.RecordNameManager;
import org.orcid.jaxb.model.notification_v2.NotificationType;
import org.orcid.persistence.dao.GenericDao;
import org.orcid.persistence.dao.NotificationDao;
import org.orcid.persistence.dao.ProfileDao;
import org.orcid.persistence.dao.ProfileEventDao;
import org.orcid.persistence.dao.impl.ProfileEventDaoImpl;
import org.orcid.persistence.jpa.entities.NotificationServiceAnnouncementEntity;
import org.orcid.persistence.jpa.entities.ProfileEntity;
import org.orcid.persistence.jpa.entities.ProfileEventEntity;
import org.orcid.persistence.jpa.entities.ProfileEventType;
import org.orcid.pojo.ajaxForm.PojoUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.MessageSource;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class EmailFrequencyServiceAnnouncement2018 {
    private List<ProfileEventType> eventTypes = Collections.unmodifiableList(Arrays.asList(ProfileEventType.GDPR_EMAIL_FREQUENCY_UPDATES_2018_FAIL,
            ProfileEventType.GDPR_EMAIL_FREQUENCY_UPDATES_2018_NOTIFICATION_CREATED, ProfileEventType.GDPR_EMAIL_FREQUENCY_UPDATES_2018_SKIPPED));

    private static Logger LOG = LoggerFactory.getLogger(EmailFrequencyServiceAnnouncement2018.class);

    private static final String NOTIFICATION_FAMILY = "GDPR_EMALI_FREQUENCY_UPDATES";
    
    ExecutorService pool;

    private ProfileDao profileDaoReadOnly;

    private MessageSource messages;

    private TemplateManager templateManager;

    private ProfileEventDao profileEventDao;    

    private NotificationDao notificationDao;
    
    private OrcidUrlManager orcidUrlManager;
    
    private RecordNameManager recordNameManager;

    private static final int CHUNK_SIZE = 50000;

    @Option(name = "-testSendToOrcids", usage = "Call only on passed ORCID Ids")
    private String orcs;
    
    @Option(name = "-mt", usage = "How many pararel threads should run")
    private Integer maxThreads;
    
    public static void main(String... args) {
        EmailFrequencyServiceAnnouncement2018 efsa = new EmailFrequencyServiceAnnouncement2018();

        CmdLineParser parser = new CmdLineParser(efsa);
        if (args == null) {
            parser.printUsage(System.err);
        }
        try {
            parser.parseArgument(args);
            efsa.init();
            efsa.execute();
        } catch (CmdLineException | InterruptedException e) {
            System.err.println(e.getMessage());
            parser.printUsage(System.err);
            System.exit(1);
        }
        System.exit(0);
    }

    private void init() {
        if(maxThreads == null || maxThreads > 64 || maxThreads < 1) {
            pool = Executors.newFixedThreadPool(8);
        } else {
            pool = Executors.newFixedThreadPool(maxThreads);
        }        
        
        ApplicationContext context = new ClassPathXmlApplicationContext("orcid-core-context.xml");
        profileDaoReadOnly = (ProfileDao) context.getBean("profileDaoReadOnly");
        messages = (MessageSource) context.getBean("messageSource");
        templateManager = (TemplateManager) context.getBean("templateManager");
        profileEventDao = (ProfileEventDao) context.getBean("profileEventDao");
        notificationDao = (NotificationDao) context.getBean("notificationDao");
        orcidUrlManager = (OrcidUrlManager) context.getBean("orcidUrlManager");
        recordNameManager = (RecordNameManager) context.getBean("recordNameManagerV3");
    }

    private void execute() throws InterruptedException {
        LOG.info("Start");
        List<String> orcids = new ArrayList<String>();  
        int doneCount = 0;
        do {
            long startTime = System.currentTimeMillis();
            orcids = profileDaoReadOnly.findByMissingEventTypes(CHUNK_SIZE, eventTypes, null, true);
            Date now = new Date();
            Set<Callable<Boolean>> callables = new HashSet<Callable<Boolean>>();
            for (String orcid : orcids) {
                callables.add(new Callable<Boolean>() {
                    @Override
                    public Boolean call() throws Exception {
                        processNotification(orcid, now);
                        return true;
                    }
                    
                });
            }
            // Runthem all 
            pool.invokeAll(callables);
            doneCount += callables.size();
            long endTime = System.currentTimeMillis();
            String timeTaken = DurationFormatUtils.formatDurationHMS(endTime - startTime);
            LOG.info("DoneCount={}, timeTaken={} (H:m:s.S)", doneCount, timeTaken);
        } while (!orcids.isEmpty());
    }
    
    private void processNotification(String orcid, Date now) {
        LOG.info("Processing {}", orcid);
        try {
            ProfileEntity profileEntity = profileDaoReadOnly.find(orcid);
            if (!profileEntity.isAccountNonLocked() || profileEntity.getPrimaryRecord() != null || profileEntity.getDeactivationDate() != null
                    || (profileEntity.getClaimed() != null && !profileEntity.getClaimed())) {
                profileEventDao.persist(new ProfileEventEntity(orcid, ProfileEventType.GDPR_EMAIL_FREQUENCY_UPDATES_2018_SKIPPED));
                return;
            }
            Locale locale = getUserLocale(profileEntity.getLocale());
            Map<String, Object> templateParams = new HashMap<String, Object>();
            String emailName = recordNameManager.deriveEmailFriendlyName(profileEntity.getId());
            templateParams.put("emailName", emailName);
            templateParams.put("messages", this.messages);
            templateParams.put("messageArgs", new Object[0]);
            templateParams.put("locale", locale);
            templateParams.put("baseUri", orcidUrlManager.getBaseUrl());
            
            String subject = "ORCID and Your Data Privacy";
            String text = templateManager.processTemplate("gdpr_email_frequencies_service_announcement.ftl", templateParams);
            String html = templateManager.processTemplate("gdpr_email_frequencies_service_announcement_html.ftl", templateParams);

            NotificationServiceAnnouncementEntity entity = new NotificationServiceAnnouncementEntity();
            entity.setBodyHtml(html);
            entity.setBodyText(text);
            entity.setSubject(subject);
            entity.setNotificationType(NotificationType.SERVICE_ANNOUNCEMENT.name());
            entity.setNotificationFamily(NOTIFICATION_FAMILY);
            entity.setOrcid(orcid);
            entity.setSendable(true);
            notificationDao.persist(entity);
            profileEventDao.persist(new ProfileEventEntity(orcid, ProfileEventType.GDPR_EMAIL_FREQUENCY_UPDATES_2018_NOTIFICATION_CREATED));
        } catch (Exception e) {
            LOG.error("Exception for: {}", orcid);
            LOG.error("Error", e);
            profileEventDao.persist(new ProfileEventEntity(orcid, ProfileEventType.GDPR_EMAIL_FREQUENCY_UPDATES_2018_FAIL));
        }
    }
    
    private Locale getUserLocale(String localeStr) {
        if (PojoUtil.isEmpty(localeStr)) {
            return LocaleUtils.toLocale("en");
        }

        org.orcid.jaxb.model.common_v2.Locale locale = org.orcid.jaxb.model.common_v2.Locale.valueOf(localeStr);
        if (locale != null) {
            return LocaleUtils.toLocale(locale.value());
        }

        return LocaleUtils.toLocale("en");
    }    
}
