package org.orcid.core.web.filters;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.net.URISyntaxException;

import javax.annotation.Resource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.orcid.test.OrcidJUnit4ClassRunner;
import org.springframework.test.context.ContextConfiguration;

/**
 * 
 * @author Angel Montenegro
 * 
 */
@RunWith(OrcidJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:test-orcid-core-context.xml" })
public class CrossDomainWebMangerTest {
    
    @Resource
    CrossDomainWebManger crossDomainWebManger;
    
    String [] allowedDomains = {"http://localhost", "https://localhost"};
    String [] forbiddenDomains = {"http://.orcid.org", "http://www.otherorcid.org", "http://www.myorcid.org", "http://www.testorcid.org", "http://qa.testorcid.org", "https://.orcid.org", "https://www.otherorcid.org", "https://www.myorcid.org", "https://www.testorcid.org", "https://qa.testorcid.org"};
    
    String [] allowedPaths = {"/lang.json","/userStatus.json","/oauth/userinfo","/oauth/jwks","/.well-known/openid-configuration"};
    String [] forbiddenPaths = {"/oauth","/whatever/oauth","/whatever/oauth/","/whatever/oauth/other",
            "/whatever/userStatus.json","/userstatus.json","/userStatus.json/","/userStatus.json/whatever",
            "/userStatus.jsonwhatever/test","/userStatus.json/whatever","/userStatus.jsonwhatever","/userStatus.jsonwhatever/test"};
    
    @Test
    public void testDomains() throws URISyntaxException {
        for(String allowed : allowedDomains) {            
            assertTrue("testing: " +  allowed, crossDomainWebManger.validateDomain(allowed));
        }  
        
        for(String forbidden : forbiddenDomains) {
            assertFalse("Testing: " + forbidden, crossDomainWebManger.validateDomain(forbidden));
        }
    }
    
    @Test
    public void testPaths() throws URISyntaxException {
        for(String allowed : allowedPaths) {            
            assertTrue("testing: " +  allowed, crossDomainWebManger.validatePath(allowed));
        }  
        
        for(String forbidden : forbiddenPaths) {
            assertFalse("Testing: " + forbidden, crossDomainWebManger.validatePath(forbidden));
        }
    }
}
