package org.orcid.core.manager.read_only.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.orcid.core.adapter.JpaJaxbEmailAdapter;
import org.orcid.core.manager.read_only.EmailManagerReadOnly;
import org.orcid.core.manager.v3.EmailManager;
import org.orcid.core.togglz.Features;
import org.orcid.jaxb.model.record_v2.Email;
import org.orcid.jaxb.model.record_v2.Emails;
import org.orcid.persistence.dao.EmailDao;
import org.orcid.persistence.jpa.entities.EmailEntity;
import org.orcid.pojo.ajaxForm.PojoUtil;

/**
 * 
 * @author Will Simpson
 * 
 */
public class EmailManagerReadOnlyImpl extends ManagerReadOnlyBaseImpl implements EmailManagerReadOnly {
    @Resource
    protected JpaJaxbEmailAdapter jpaJaxbEmailAdapter;
    
    protected EmailDao emailDao;
    
    @Resource(name = "emailManagerV3")
    protected EmailManager emailManagerV3;
    
    public void setEmailDao(EmailDao emailDao) {
        this.emailDao = emailDao;
    }

    @Override
    public boolean emailExists(String email) {
        Map<String, String> emailKeys = emailManagerV3.getEmailKeys(email);       
        String hash = emailKeys.get(org.orcid.core.manager.v3.EmailManager.HASH);
        return emailDao.emailExists(hash);        
    }

    @Override
    public String findOrcidIdByEmail(String email) {        
        Map<String, String> emailKeys = emailManagerV3.getEmailKeys(email);       
        String hash = emailKeys.get(org.orcid.core.manager.v3.EmailManager.HASH);
        return emailDao.findOrcidIdByEmailHash(hash);
    }
    
    @Override
    public boolean isPrimaryEmail(String orcid, String email) {
        return emailDao.isPrimaryEmail(orcid, email);
    }
    
    @Override
    @SuppressWarnings("rawtypes")
    public Map<String, String> findOricdIdsByCommaSeparatedEmails(String csvEmail) {
        Map<String, String> emailIds = new TreeMap<String, String>(String.CASE_INSENSITIVE_ORDER);
        List<String> emailList = new ArrayList<String>();
        String [] emails = csvEmail.split(",");
        for(String email : emails) {
            if(StringUtils.isNotBlank(email.trim()))
                emailList.add(email.trim());
        }
        List ids = emailDao.findIdByCaseInsensitiveEmail(emailList);
        for (Iterator it = ids.iterator(); it.hasNext(); ) {
            Object[] orcidEmail = (Object[]) it.next();
            String orcid = (String) orcidEmail[0];
            String email = (String) orcidEmail[1];
            emailIds.put(email, orcid);
        }
        return emailIds;
    }
    
    @Override
    @SuppressWarnings("rawtypes")
    public Map<String, String> findIdsByEmails(List<String> emailList) {
        Map<String, String> emailIds = new TreeMap<String, String>(String.CASE_INSENSITIVE_ORDER);
        List ids = emailDao.findIdByCaseInsensitiveEmail(emailList);
        for (Iterator it = ids.iterator(); it.hasNext();) {
            Object[] orcidEmail = (Object[]) it.next();
            String orcid = (String) orcidEmail[0];
            String email = (String) orcidEmail[1];
            emailIds.put(email, orcid);
        }
        return emailIds;
    }
        
    @Override
    public Emails getEmails(String orcid) {
        List<EmailEntity> entities = emailDao.findByOrcid(orcid, getLastModified(orcid));
        return toEmails(entities);
    }
    
    @Override
    public Emails getVerifiedEmails(String orcid) {
        List<EmailEntity> entities = emailDao.findByOrcid(orcid, getLastModified(orcid));
        if (entities == null) {
            return new Emails();
        }
        return toEmails(entities.stream().filter(e -> e.getVerified()).collect(Collectors.toList()));
    }
    
    @Override
    public Emails getPublicEmails(String orcid) {
        List<EmailEntity> entities = emailDao.findPublicEmails(orcid, getLastModified(orcid));
        return toEmails(entities);
    }
    
    private Emails toEmails(List<EmailEntity> entities) {
        List<org.orcid.jaxb.model.record_v2.Email> emailList = jpaJaxbEmailAdapter.toEmailList(entities);
        Emails emails = new Emails();
        emails.setEmails(emailList);        
        return emails;
    }
    
    @Override
    public boolean haveAnyEmailVerified(String orcid) {
        List<EmailEntity> entities = emailDao.findByOrcid(orcid, getLastModified(orcid));
        if(entities != null) {
            for(EmailEntity email : entities) {
                if(email.getVerified()) {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public EmailEntity find(String email) {
        Map<String, String> emailKeys = emailManagerV3.getEmailKeys(email);       
        String hash = emailKeys.get(org.orcid.core.manager.v3.EmailManager.HASH);
        return emailDao.find(hash);
    }

    @Override
    public Email findPrimaryEmail(String orcid) {
        if(PojoUtil.isEmpty(orcid)) {
            return null;
        }
        return jpaJaxbEmailAdapter.toEmail(emailDao.findPrimaryEmail(orcid));
    }
    
}
