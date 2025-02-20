package org.orcid.core.manager.impl;

import java.util.Random;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.ehcache.Cache;
import org.orcid.core.crypto.OrcidCheckDigitGenerator;
import org.orcid.core.manager.OrcidGenerationManager;
import org.orcid.core.manager.ProfileEntityManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Will Simpson (will) Date: 15/02/2012
 */
public class OrcidGenerationManagerImpl implements OrcidGenerationManager {

    private static final Logger LOGGER = LoggerFactory.getLogger(OrcidGenerationManager.class);

    @Resource
    private ProfileEntityManager profileEntityManager;

    @Resource(name = "recentOrcidCache")
    private Cache<String, String> recentOrcidCache;

    private final long ORCID_IDS_V2_RANGE_SIZE = (ORCID_BASE_V2_MAX - ORCID_BASE_V2_MIN + 1);
    
    @Override
    public String createNewOrcid() {
        String orcid = getNextOrcid();
        while (isInRecentOrcidCache(orcid) || profileEntityManager.orcidExists(orcid)) {
            orcid = getNextOrcid();
        }
        
        recentOrcidCache.put(orcid, orcid);
        return orcid;
    }

    private String getNextOrcid() {
        String baseOrcid = StringUtils.leftPad(String.valueOf(getRandomNumber()), 15, '0');
        String checkDigit = OrcidCheckDigitGenerator.generateCheckDigit(baseOrcid);
        return formatOrcid(baseOrcid + checkDigit);
    }

    private boolean isInRecentOrcidCache(String formattedOrcid) {
        if (recentOrcidCache.containsKey(formattedOrcid)) {
            LOGGER.debug("Same ORCID randomly generated a few moments ago: {}", formattedOrcid);
            return true;
        }
        return false;
    }

    private long getRandomNumber() {
        Random random = new Random();
        long randomLong = (long) (ORCID_BASE_V2_MIN + (random.nextDouble() * ORCID_IDS_V2_RANGE_SIZE)); 
        // Verify random is between valid range
        while(randomLong < ORCID_BASE_V2_MIN || randomLong > ORCID_BASE_V2_MAX) {
            randomLong = (long) (ORCID_BASE_V2_MIN + (random.nextDouble() * ORCID_IDS_V2_RANGE_SIZE)); 
        }
        
        return randomLong;              
    }

    private String formatOrcid(String orcid) {
        return orcid.replaceAll("(.{4})(?=.)", "$1-");
    }

}
