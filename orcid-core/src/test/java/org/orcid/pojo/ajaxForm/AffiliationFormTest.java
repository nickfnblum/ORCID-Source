package org.orcid.pojo.ajaxForm;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.orcid.jaxb.model.v3.release.record.Affiliation;
import org.orcid.jaxb.model.v3.release.record.summary.AffiliationSummary;

public class AffiliationFormTest extends AffiliationFormTestBase {    
        
    @Test
    public void equalsTest() {
        AffiliationForm f1 = getAffiliationForm();
        AffiliationForm f2 = getAffiliationForm();
        assertTrue(f1.equals(f2));
    }
    
    @Test
    public void fromAffiliationSummaryTest() {
        AffiliationForm f1 = getAffiliationForm();
        AffiliationSummary s1 = getAffiliationSummary();
        
        AffiliationForm f2 = AffiliationForm.valueOf(s1);
        f2.equals(f1);
        assertEquals(f1, AffiliationForm.valueOf(s1));
    }
    
    @Test
    public void fromAffiliationTest() {
        AffiliationForm f1 = getAffiliationForm();
        Affiliation aff = getAffiliation();
        assertEquals(f1, AffiliationForm.valueOf(aff));
    }
    
    @Test
    public void toAffiliationTest() {
        AffiliationForm f1 = getAffiliationForm();
        Affiliation aff = getAffiliation();
        assertEquals(aff, f1.toAffiliation());
    }        
}
