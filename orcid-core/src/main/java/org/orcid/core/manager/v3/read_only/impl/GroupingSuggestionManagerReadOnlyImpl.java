package org.orcid.core.manager.v3.read_only.impl;

import java.util.List;

import javax.annotation.Resource;

import org.orcid.core.manager.v3.GroupingSuggestionsCacheManager;
import org.orcid.core.manager.v3.read_only.GroupingSuggestionManagerReadOnly;
import org.orcid.pojo.grouping.WorkGroupingSuggestion;
import org.orcid.pojo.grouping.WorkGroupingSuggestions;
import org.orcid.pojo.grouping.WorkGroupingSuggestionsCount;

public class GroupingSuggestionManagerReadOnlyImpl implements GroupingSuggestionManagerReadOnly {

    @Resource
    protected GroupingSuggestionsCacheManager groupingSuggestionsCacheManager;

    @Override
    public WorkGroupingSuggestions getGroupingSuggestions(String orcid) {
        boolean more = groupingSuggestionsCacheManager.getGroupingSuggestionCount(orcid) > SUGGESTION_BATCH_SIZE;
        List<WorkGroupingSuggestion> suggestions = groupingSuggestionsCacheManager.getGroupingSuggestions(orcid, SUGGESTION_BATCH_SIZE);
        return getWorkGroupingSuggestions(suggestions, more);
    }

    @Override
    public WorkGroupingSuggestionsCount getGroupingSuggestionCount(String orcid) {
        WorkGroupingSuggestionsCount count = new WorkGroupingSuggestionsCount();
        count.setOrcid(orcid);
        count.setCount(groupingSuggestionsCacheManager.getGroupingSuggestionCount(orcid));
        return count;
    }
    
    private WorkGroupingSuggestions getWorkGroupingSuggestions(List<WorkGroupingSuggestion> suggestions, boolean more) {
        WorkGroupingSuggestions workGroupingSuggestions = new WorkGroupingSuggestions();
        workGroupingSuggestions.setMoreAvailable(more);
        workGroupingSuggestions.setSuggestions(suggestions);
        return workGroupingSuggestions;
    }

    
}
