<script type="text/ng-template" id="works-ng2-template">
    <!--WORKS-->
    <div [hidden]="publicView == 'true' && recordLocked" id="workspace-publications" class="workspace-accordion-item workspace-accordion-active" role="group" aria-labelledby="affiliationType.Works" aria-describedby="tooltip-helpPopoverWorks">
        <!--Works section header--> 
        <div class="workspace-accordion-header clearfix">
            <div class="row">
                <div class="col-md-5 col-sm-5 col-xs-12">                
                    <div class="affiliation-heading">
                        <a (click)="toggleSectionDisplay($event)" class="toggle-text">
                           <i class="glyphicon-chevron-down glyphicon x075" [ngClass]="{'glyphicon-chevron-right':workspaceSrvc.displayWorks==false}"></i>
                           <h2 id="affiliationType.Works">
                                <@orcid.msg 'workspace.Works'/> 
                                <ng-container>
                                    (<span>{{worksService.groupsLabel}}</span>)
                                </ng-container>
                           </h2>
                        </a>
                        <div *ngIf="!isPublicPage" class="popover-help-container">
                            <i class="glyphicon glyphicon-question-sign"></i>
                            <div id="works-help" class="popover bottom">
                                <div class="arrow"></div>
                                <div class="popover-content">
                                    <p id="tooltip-helpPopoverWorks"><@orcid.msg 'manage_works_settings.helpPopoverWorks'/> <a href="<@orcid.msg 'common.kb_uri_default'/>360006973133" target="manage_works_settings.helpPopoverWorks"><@orcid.msg 'common.learn_more'/></a></p>
                                </div>
                            </div>
                        </div> 
                    </div>
                </div>
                <div *ngIf="workspaceSrvc.displayWorks" class="col-md-7 col-sm-7 col-xs-12 action-button-bar">
                    <!--Sort menu-->
                    <div class="menu-container">                                     
                        <ul class="toggle-menu">
                            <li>
                                <span class="glyphicon glyphicon-sort"></span>
                                <@orcid.msg 'manual_orcid_record_contents.sort'/>
                                <ul class="menu-options sort">
                                    <li [ngClass]="{'checked':sortKey=='date'}">                                          
                                        <a (click)="sort('date');" class="action-option manage-button">
                                            <@orcid.msg 'manual_orcid_record_contents.sort_date'/>
                                            <span *ngIf="!sortAsc" [ngClass]="{'glyphicon glyphicon-sort-by-order-alt':sortKey=='date'}"></span>
                                            <span *ngIf="sortAsc" [ngClass]="{'glyphicon glyphicon-sort-by-order':sortKey=='date'}"></span>
                                        </a>
                                    </li>
                                    <li [ngClass]="{'checked':sortKey=='title'}" *ngIf="!sortHideOption">
                                        <a (click)="sort('title');" class="action-option manage-button">
                                            <@orcid.msg 'manual_orcid_record_contents.sort_title'/>
                                            <span *ngIf="!sortAsc" [ngClass]="{'glyphicon glyphicon-sort-by-alphabet-alt':sortKey=='title'}" ></span>
                                            <span *ngIf="sortAsc" [ngClass]="{'glyphicon glyphicon-sort-by-alphabet':sortKey=='title'}" ></span>
                                        </a>  
                                    </li>
                                    <li [ngClass]="{'checked':sortKey=='type'}">                                          
                                        <a (click)="sort('type');" class="action-option manage-button">
                                            <@orcid.msg 'manual_orcid_record_contents.sort_type'/>
                                            <span *ngIf="!sortAsc" [ngClass]="{'glyphicon glyphicon-sort-by-alphabet-alt':sortKey=='type'}"></span>
                                            <span *ngIf="sortAsc" [ngClass]="{'glyphicon glyphicon-sort-by-alphabet':sortKey=='type'}"></span>
                                        </a>       
                                    </li>
                                </ul>                                           
                            </li>
                        </ul>                                   
                    </div>
                    <!--End sort menu-->
                    <ul *ngIf="!isPublicPage" class="workspace-bar-menu">
                        <!--Bulk edit-->
                        <li *ngIf="!manualWorkGroupingEnabled && worksService?.groups?.length > 1" >
                            <a class="action-option works manage-button" [ngClass]="{'green-bg' : bulkEditShow == true}" (click)="toggleBulkEdit()" aria-label="<@orcid.msg 'common.edit' />">
                                <span class="glyphicon glyphicon-pencil"></span><@orcid.msg 'groups.common.bulk_edit'/>
                            </a>
                        </li>
                        <!--Export bibtex-->
                        <li *ngIf="worksService?.groups?.length > 0" >
                            <a class="action-option works manage-button" [ngClass]="{'green-bg' : showBibtexExport}" (click)="toggleBibtexExport()">
                                <span class="glyphicon glyphicon-save"></span>
                                <@orcid.msg 'groups.common.export_works'/>
                            </a>
                        </li>
                        <!--Add works-->
                        <li class="hidden-xs">
                            <div class="menu-container" id="add-work-container">
                                <ul class="toggle-menu">
                                    <li [ngClass]="{'green-bg' : showBibtexImportWizard == true || workImportWizard == true}"> 
                                        <span class="glyphicon glyphicon-plus"></span>
                                        <@orcid.msg 'groups.common.add_works'/>
                                        <span class="ai ai-arxiv" style="opacity: 0;width: 0;"></span>
                                        <ul class="menu-options works">
                                            <!--Search & link-->
                                            <li>
                                                <a class="action-option manage-button" (click)="showWorkImportWizard()">
                                                    <span class="glyphicon glyphicon-cloud-upload"></span>
                                                    <@orcid.msg 'manual_orcid_record_contents.search_link'/>
                                                </a>
                                            </li>
                                            <!--  ADD WORKS WITH EXTERNAL ID CONTAINER-->
                                            <li>
                                                <a class="action-option manage-button" (click)="addWorkExternalIdModal('arXiv')">
                                                    <span class="ai ai-arxiv"></span>
                                                    <@orcid.msg 'groups.common.add_arxiv'/>
                                                </a>
                                            </li>

                                            <li>
                                                <a class="action-option manage-button" (click)="addWorkExternalIdModal('DOI')">
                                                    <span class="ai ai-doi"></span>
                                                    <@orcid.msg 'groups.common.add_doi'/>
                                                </a>
                                            </li>
                                            <li >
                                                <a class="action-option manage-button" (click)="addWorkExternalIdModal('pubMed')">
                                                    <span class="ai ai-pubmed"></span>
                                                    <@orcid.msg 'groups.common.add_pubmed'/>    
                                                </a>
                                            </li>
                                            <!--Add from Bibtex-->
                                            <li>
                                                <a class="action-option manage-button" (click)="openBibTextWizard()">
                                                    <span class="glyphicons file_import bibtex-wizard"></span>
                                                    <@orcid.msg 'workspace.bibtexImporter.link_bibtex'/>
                                                </a>
                                            </li>
                                            <!--Add manually-->
                                            <li>
                                                <a id="add-work" class="action-option manage-button" (click)="addWorkModal()">
                                                    <span class="glyphicon glyphicon-plus"></span>
                                                    <@orcid.msg 'manual_orcid_record_contents.link_manually'/>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                        </li>
                        <!--Import Search & link-->
                        <li class="hidden-md hidden-sm visible-xs-inline">
                            <a *ngIf="noLinkFlag" class="action-option manage-button" (click)="showWorkImportWizard()">
                                <span class="glyphicon glyphicon-cloud-upload"></span>
                                <@orcid.msg 'manual_orcid_record_contents.search_link'/>
                            </a>
                        </li>
                        <!--Import Bibtex-->
                        <li class="hidden-md hidden-sm visible-xs-inline">
                            <a class="action-option manage-button" (click)="openBibTextWizard()">
                                <span class="glyphicons file_import bibtex-wizard"></span>
                                <@orcid.msg 'workspace.bibtexImporter.link_bibtex'/>
                            </a>
                        </li>
                        <!--Mobile workaraound-->
                        <li class="hidden-md hidden-sm visible-xs-inline">
                            <a class="action-option manage-button" (click)="addWorkModal()">
                                <span class="glyphicon glyphicon-plus"></span>
                                <@orcid.msg 'manual_orcid_record_contents.link_manually'/>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <!--End works section header-->
        <!-- Work Import Wizard -->
        <div *ngIf="workImportWizard" class="work-import-wizard">
            <div class="ie7fix-inner">
                <div class="row"> 
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <h1 class="lightbox-title wizard-header"><@orcid.msg 'workspace.link_works'/></h1>
                        <span (click)="showWorkImportWizard()" class="close-wizard"><@orcid.msg 'workspace.LinkResearchActivities.hide_link_works'/></span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <p class="wizard-content">
                            <@orcid.msg 'workspace.LinkResearchActivities.description'/> <a target="workspace.LinkResearchActivities.description.more_info" href="https://support.orcid.org/hc/en-us/articles/360006973653-Add-works-by-direct-import-from-other-systems"> <@orcid.msg 'workspace.LinkResearchActivities.description.more_info'/> </a>
                        </p>
                    </div>
                </div>
                <div class="row">
                    <div id="workFilters">
                        <form class="form-inline">
                            <div class="col-md-5 col-sm-5 col-xs-12">
                                <div class="form-group">
                                    <label for="work-type"><@orcid.msg 'workspace.link_works.filter.worktype'/></label> 
                                    <select id="work-type" name="work-type" [(ngModel)]="selectedWorkType">
                                        <option *ngFor="let wt of workType">{{wt}}</option>
                                    </select> 
                                </div> 
                            </div>
                            <div class="col-md-7 col-sm-7 col-xs-12">
                                <div class="form-group geo-area-group">
                                    <label for="geo-area"><@orcid.msg 'workspace.link_works.filter.geographicalarea'/></label>
                                    <select id="geo-area" name="geo-area" [(ngModel)]="selectedGeoArea">
                                        <option *ngFor="let ga of geoArea">{{ga}}</option>
                                    </select>   
                                </div>
                            </div>  
                        </form>
                        <hr />
                    </div>
                </div>         
                <div class="row wizards">               
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <div *ngFor="let wtw of workImportWizardsOriginal | orderBy: 'name' | filterImportWizards : selectedWorkType : selectedGeoArea; let index = index; let first = first; let last = last;">
                            <strong><a (click)="openImportWizardUrlFilter(getBaseUri() + '/oauth/authorize', wtw)">{{wtw.name}}</a></strong>

                            <br />                                                                                    
                            <div class="justify">                       
                                <p class="wizard-description" [ngClass]="{'ellipsis-on' : wizardDescExpanded[wtw.id] == false || wizardDescExpanded[wtw.id] == null}">
                                    {{wtw.description}}
                                    <a (click)="toggleWizardDesc(wtw.id)" *ngIf="wizardDescExpanded[wtw.id]"><span class="glyphicon glyphicon-chevron-right wizard-chevron"></span></a>
                                </p>                        
                                <a (click)="toggleWizardDesc(wtw.id)" *ngIf="wizardDescExpanded[wtw.id] == false || wizardDescExpanded[wtw.id] == null" class="toggle-wizard-desc"><span class="glyphicon glyphicon-chevron-down wizard-chevron"></span></a>
                            </div>
                            <hr/>
                        </div>
                    </div>
                </div>
            </div>            
        </div>
        <!--End import wizard-->
        <!-- Bulk Edit -->  
        <div *ngIf="bulkEditShow && workspaceSrvc.displayWorks" >           
            <div class="bulk-edit">
                <div class="row">
                    <div class="col-md-7 col-sm-7 col-xs-12">
                        <h4><@orcid.msg 'workspace.bulkedit.title'/></h4><span class="hide-bulk" (click)="toggleBulkEdit()"><@orcid.msg 'workspace.bulkedit.hide'/></span>
                        <ol>
                            <li><@orcid.msg 'workspace.bulkedit.selectWorks'/></li>
                            <li><@orcid.msg 'workspace.bulkedit.selectAction'/></li>
                        </ol>
                    </div>
                    <div class="col-md-5 col-sm-5 col-xs-12">
                        <ul class="bulk-edit-toolbar">
                            <li class="bulk-edit-toolbar-item work-multiple-selector">
                                <label><@orcid.msg 'workspace.bulkedit.select'/></label>
                                <div id="custom-control-x">
                                    <div class="custom-control-x" > 
                                        <div class="dropdown-custom-menu" id="dropdown-custom-menu" (click)="toggleSelectMenu();$event.stopPropagation()">                  
                                            <span class="custom-checkbox-parent">
                                                <div class="custom-checkbox" id="custom-checkbox" (click)="swapbulkChangeAll();$event.stopPropagation();" [ngClass]="{'custom-checkbox-active':bulkChecked}"></div>
                                            </span>                   
                                            <div class="custom-control-arrow" (click)="toggleSelectMenu(); $event.stopPropagation()"></div>                            
                                        </div>
                                        <div>
                                            <ul class="dropdown-menu" role="menu" id="special-menu" [ngClass]="{'block': bulkDisplayToggle}">
                                                <li><a (click)="bulkChangeAll(true)"><@orcid.msg 'workspace.bulkedit.selected.all'/></a></li>
                                                <li><a (click)="bulkChangeAll(false)"><@orcid.msg 'workspace.bulkedit.selected.none'/></a></li>                                                
                                            </ul>     
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li class="bulk-edit-toolbar-item">
                                <label><@orcid.msg 'workspace.bulkedit.edit'/></label>
                                <div class="bulk-edit-privacy-control">
                                    <@orcid.privacyToggle2Ng2 angularModel="none" elementId="none" 
                                    questionClick=""
                                    clickedClassCheck=""
                                    publicClick="setBulkGroupPrivacy('PUBLIC', $event)" 
                                    limitedClick="setBulkGroupPrivacy('LIMITED', $event)" 
                                    privateClick="setBulkGroupPrivacy('PRIVATE', $event)"/>
                                </div>                    
                            </li>                   
                        </ul>
                        <div class="bulk-edit-delete">
                            <div class="centered">
                                <a (click)="deleteBulkConfirm()" class="ignore toolbar-button edit-item-button">
                                    <span class="edit-option-toolbar glyphicon glyphicon-trash"></span>
                                </a>
                            </div>
                        </div>
                    </div>              
                </div>              
            </div>
        </div>
        <!--End bulk edit-->
        <!-- Bibtex export -->        
        <div *ngIf="showBibtexExport && workspaceSrvc.displayWorks" class="bibtex-box">
            <div *ngIf="canReadFiles" >
                <h4><@orcid.msg 'workspace.bibtexExporter.export_bibtex'/></h4><span (click)="toggleBibtexExport()" class="hide-importer"><@orcid.msg 'workspace.bibtexExporter.hide'/></span>
                <div class="row full-height-row">
                    <div class="col-md-9 col-sm-9 col-xs-8">
                        <p>
                            <@orcid.msg 'workspace.bibtexExporter.intro_1'/><a href="<@orcid.msg 'common.kb_uri_default'/>360006971453" target="exporting_bibtex" style="word-break\: normal;"><@orcid.msg 'workspace.bibtexExporter.intro_2'/></a><@orcid.msg 'workspace.bibtexExporter.intro_3'/>
                        </p> 
                    </div>
                    <div class="col-md-3 col-sm-3 col-xs-4">
                        <span class="bibtext-options">                                        
                            <a class="bibtex-cancel" (click)="toggleBibtexExport()"><@orcid.msg 'workspace.bibtexExporter.cancel'/></a>             
                            <span *ngIf="!(worksFromBibtex?.length > 0)" class="import-label" (click)="fetchBibtexExport()"><@orcid.msg 'workspace.bibtexExporter.export'/></span>                   
                        </span>                   
                    </div>
                </div>
            </div>
            <div class="bottomBuffer" *ngIf="bibtexExportLoading && !bibtexExportError" >
                <span class="dotted-bar"></span>
                <ul class="inline-list">
                    <li>
                        <@orcid.msg 'workspace.bibtexExporter.generating'/>
                    </li>
                    <li>
                        &nbsp;<span><i id="" class="glyphicon glyphicon-refresh spin x1 green"></i></span>    
                    </li>
                </ul>
            </div>
    
            <div class="alert alert-block" *ngIf="bibtexExportError">
                <strong><@orcid.msg 'workspace.bibtexExporter.error'/></strong>
            </div>
          
        </div>   
        <!--End bibtex export-->
        <!-- Bibtex Importer Wizard -->
        <div *ngIf="showBibtexImportWizard && workspaceSrvc.displayWorks"  class="bibtex-box">
            <div *ngIf="canReadFiles" >
                <h4><@orcid.msg 'workspace.bibtexImporter.link_bibtex'/></h4><span (click)="openBibTextWizard()" class="hide-importer"><@orcid.msg 'workspace.bibtexImporter.hide_link_bibtex'/></span>
                <div class="row full-height-row">
                    <div class="col-md-9 col-sm-9 col-xs-8">
                        <p>
                            <@orcid.msg 'workspace.bibtexImporter.instructions'/> <a href="https://support.orcid.org/hc/en-us/articles/360006894794-Importing-works-from-a-BibTeX-file" rel="noopener noreferrer" target="orcid.blank"><@orcid.msg 'workspace.bibtexImporter.learnMore'/></a>.
                        </p> 
                    </div>
                    <div class="col-md-3 col-sm-3 col-xs-4">
                        <span class="bibtext-options">                                        
                            <a class="bibtex-cancel" (click)="openBibTextWizard()"><@orcid.msg 'workspace.bibtexImporter.cancel'/></a>            
                            <label for="inputBibtex" *ngIf="!(worksFromBibtex?.length > 0)" class="import-label" ><@orcid.msg 'workspace.bibtexImporter.fileUpload'/></label>
                            <span *ngIf="worksFromBibtex?.length > 0" class="import-label" (click)="saveAllFromBibtex()"><@orcid.msg 'workspace.bibtexImporter.save_all'/></span>                                     
                            <input id="inputBibtex" name="textFiles" type="file" class="upload-button" accept="*" (change)="loadBibtexJs($event)" app-file-text-reader multiple/>

                        </span>                   
                    </div>
                </div>
            </div> 
            <div class="bottomBuffer text-center" *ngIf="bibtexImportLoading && !bibtexParsingError" >
                <i class="glyphicon glyphicon-refresh spin x4 green" id="spinner"></i>
            </div>          
            <div class="alert alert-block" *ngIf="bibtexParsingError">
                <strong><@orcid.msg 'workspace.bibtexImporter.parsingError'/></strong>
                <pre>{{bibtexParsingErrorText}}</pre>
            </div>
            <span class="dotted-bar" *ngIf="worksFromBibtex?.length > 0"></span>
            <!-- Bibtex Import Results List -->
            <ng-container *ngIf="!bibtexImportLoading">
                <div *ngFor="let work of worksFromBibtex; let index = index; let first = first; let last = last;" class="bottomBuffer">             
                    <div class="row full-height-row">   
                        <div class="col-md-9 col-sm-9 col-xs-7">
                            <h3 class="workspace-title" [ngClass]="work.title?.value == null ? 'bibtex-content-missing' :  ''">
                                <span *ngIf="work.title?.value != null">{{work.title.value}}</span>
                                <span *ngIf="work.title?.value == null">&lt;<@orcid.msg 'workspace.bibtexImporter.work.title_missing' />&gt;</span>
                                <span class="journaltitle" *ngIf="work.journalTitle?.value">{{work.journalTitle.value}}</span>
                            </h3>

                            <div class="info-detail">
                                <span *ngIf="work.publicationDate.year">{{work.publicationDate.year}}</span><span *ngIf="work.publicationDate?.month">-{{work.publicationDate.month}}</span><span *ngIf="work.publicationDate?.day">-</span><span *ngIf="work.publicationDate?.day">{{work.publicationDate.day}}</span><span *ngIf="work.publicationDate.year"> | </span>
                      
                                <span class="capitalize" *ngIf="work.workType?.value?.length > 0">{{work.workType.value}}</span>
                                <span class="bibtex-content-missing small-missing-info" *ngIf="work.workType?.value?.length == 0">&lt;<@orcid.msg 'workspace.bibtexImporter.work.type_missing' />&gt;</span>

                            </div>
                            <div class="row" *ngIf="work?.workExternalIdentifiers[0]?.externalIdentifierId?.value">
                                <div class="col-md-12 col-sm-12 bottomBuffer">
                                    <ul class="id-details">
                                        <li class="url-work">
                                            <ul class="id-details">
                                                <li *ngFor='let extID of work.workExternalIdentifiers | orderBy:["relationship.value", "externalIdentifierType.value"]; let index = index; let first = first; let last = last;' class="url-popover">
                                                    <span *ngIf="work?.workExternalIdentifiers[0]?.externalIdentifierId?.value?.length > 0">
                                                        <ext-id-popover-ng2 [extID]="extID" [putCode]="'bibtexWork'+i" [activityType]="'work'"></ext-id-popover-ng2>
                                                    </span>
                                                </li>
                                            </ul>                                   
                                        </li>

                                        <li *ngIf="work.url?.value" class="url-popover url-work">
                                            <@orcid.msg 'common.url' />: <a href="{{work.url.value | urlProtocol}}" (mouseenter)="showURLPopOver('bibtexWork'+index)" (mouseleave)="hideURLPopOver('bibtexWork'+index)" [ngClass]="{'truncate-anchor' : moreInfo[group?.groupId] == false || moreInfo[group?.groupId] == undefined}" rel="noopener noreferrer" target="work.url.value">{{work.url.value}}</a>
                                            <div class="popover-pos">                                   
                                                <div class="popover-help-container">
                                                    <div class="popover bottom" [ngClass]="{'block' : displayURLPopOver['bibtexWork'+index] == true}">
                                                        <div class="arrow"></div>
                                                        <div class="popover-content">
                                                            <a href="{{work.url.value}}" rel="noopener noreferrer" target="work.url.value">{{work.url.value}}</a>
                                                        </div>                
                                                    </div>                              
                                                </div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>                          
                        <div class="col-md-3 col-sm-3 col-xs-3 bibtex-options-menu">                   
                            <ul>
                                <li><a (click)="rmWorkFromBibtex(work)" class="ignore glyphicon glyphicon-trash bibtex-button" title="<@orcid.msg 'common.ignore' />"></a></li>
                                <li><a *ngIf="work?.errors?.length == 0" (click)="addWorkFromBibtex(work)" class="save glyphicon glyphicon-floppy-disk bibtex-button" title="<@orcid.msg 'common.save' />"></a></li>
                                <li><a *ngIf="work?.errors?.length > 0" (click)="editWorkFromBibtex(work)" class="save glyphicon glyphicon-pencil bibtex-button" aria-label="<@orcid.msg 'common.edit' />" title="<@orcid.msg 'common.edit' />"></a></li>
                                <li><span *ngIf="work?.errors?.length > 0"><a (click)="editWorkFromBibtex(work)"><i class="glyphicon glyphicon-exclamation-sign"></i><@orcid.msg 'workspace.bibtexImporter.work.warning' /></a></span></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </ng-container>
        </div>
        <!--End bibtex import wizard-->
        <!--Works list-->
        <div *ngIf="workspaceSrvc.displayWorks" class="workspace-accordion-content">            
                <div *ngIf="!isPublicPage" class="col-md-12 col-sm-12 col-xs-12">
                    <div class="work-bulk-actions row" *ngIf="worksService?.groups?.length">
                        <div class="pull-right" *ngIf="groupingSuggestionPresent">
                            
                                <button class="btn btn-primary leftBuffer" (click)="mergeSuggestionConfirm()">
                                    <@orcid.msg 'groups.combine.suggestion.manage_similar'/>
                                </button>
                    
                        </div>                        
                        <ul class="sources-actions">
                            <li>
                                <div class="left">
                                    <input type="checkbox" [ngModel]="allSelected" (click)="toggleSelectAll()" />
                                </div>
                            </li>
                            <li>
                                <div class="left leftBuffer bulk-edit-merge popover-help-container" (mouseenter)="showTooltip('worksBulkEditMerge')" 
                                    (mouseleave)="hideTooltip('worksBulkEditMerge')">
                                    <button class="btn btn-white-no-border" [disabled]="bulkSelectedCount < 2"  (click)="mergeConfirm()">
                                        <span class="edit-option-toolbar glyphicon glyphicon-resize-small"></span>
                                        <span><@orcid.msg 'workspace.bulkedit.merge'/></span>
                                    </button>
                                    <div class="popover top" [ngClass]="showElement['worksBulkEditMerge'] == true ? 'block' : ''">
                                        <div class="arrow"></div>
                                        <div class="popover-content">
                                            <@orcid.msg 'groups.combine.helpPopover_1'/> <a href="<@orcid.msg 'common.kb_uri_default'/>360006894774" target="privacyToggle.help.more_information"> <@orcid.msg 'common.learn_more'/></a>
                                        </div>                
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="left leftBuffer bulk-edit-delete popover-help-container" (mouseenter)="showTooltip('worksBulkEditDelete')" (mouseleave)="hideTooltip('worksBulkEditDelete')">
                                    <button class="btn btn-white-no-border" [disabled]="bulkSelectedCount < 1" (click)="deleteBulkConfirm()">
                                        <span class="edit-option-toolbar glyphicon glyphicon-trash"></span>
                                        <span><@orcid.msg 'workspace.bulkedit.delete'/></span>
                                    </button>
                                    <div class="popover top" [ngClass]="showElement['worksBulkEditDelete'] == true ? 'block' : ''">
                                        <div class="arrow"></div>
                                        <div class="popover-content">
                                            <@orcid.msg 'groups.bulk_delete.helpPopover'/>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="bulk-edit-privacy-control left leftBuffer">
                                    <@orcid.privacyToggleBulkWorksNg2 angularModel="none" elementId="none" 
                                    questionClick=""
                                    clickedClassCheck=""
                                    publicClick="setBulkGroupPrivacy('PUBLIC', $event)" 
                                    limitedClick="setBulkGroupPrivacy('LIMITED', $event)" 
                                    privateClick="setBulkGroupPrivacy('PRIVATE', $event)"/>
                                </div>
                            </li>
                        </ul>
                        <div class="notification-alert clear-fix bottomBuffer" *ngIf="showMergeWorksExtIdsError || showMergeWorksApiMissingExtIdsError">
                            <@orcid.msg 'groups.combine.no_external_ids_1'/>&nbsp; 
                            <span *ngIf="showMergeWorksExtIdsError"><@orcid.msg 'groups.combine.no_external_ids_2_user_source'/></span>
                            <span *ngIf="showMergeWorksApiMissingExtIdsError"><@orcid.msg 'groups.combine.no_external_ids_2_client_source'/></span>&nbsp;<a target="groups.combine.no_external_ids_3" href="<@orcid.msg 'common.kb_uri_default'/>360006894774"><@orcid.msg 'groups.combine.no_external_ids_3'/></a>
                            <button *ngIf="showMergeWorksExtIdsError" class="btn btn-primary cancel-right pull-right topBuffer" (click)="dismissError('showMergeWorksExtIdsError')">
                                 <@orcid.msg 'common.cookies.dismiss'/>
                            </button>
                            <button *ngIf="showMergeWorksApiMissingExtIdsError" class="btn btn-primary cancel-right pull-right topBuffer" (click)="dismissError('showMergeWorksApiMissingExtIdsError')">
                                 <@orcid.msg 'common.cookies.dismiss'/>
                            </button>
                        </div>
                    </div>
                </div>            
            
                <#--  INITIAL LOADER  -->
                <div *ngIf="worksService.loading && !worksService.showPagination" class="text-center" id="workSpinner">
                    <i class="glyphicon glyphicon-refresh spin x4 green" id="spinner"></i>
                </div>
                <#--  TOP PAGINATION CONTOL  -->
                <div class="paginatorContainer col-md-12 col-sm-12 col-xs-12" *ngIf="worksService.showPagination && !this.printView">
                    <mat-paginator
                    [length]="worksService.paginationTotalAmountOfWorks"
                    [pageSize]="worksService.paginationBatchSize"
                    [pageSizeOptions]="[10, 50, 100]"
                    [pageIndex]="worksService.paginationIndex"
                    (page)="pageEvent($event)"
                    >
                    </mat-paginator>
                    <i class="glyphicon glyphicon-refresh spin x2 green" id="spinner" *ngIf="worksService?.loading"></i>
                </div>
            
                <ul *ngIf="worksService?.groups?.length" class="workspace-publications bottom-margin-medium" id="body-work-list" role="presentation">
                    <li class="bottom-margin-small workspace-border-box card" *ngFor="let group of worksService.groups">
                        <#include "work-details-ng2.ftl"/>  
                    </li>
                </ul>
            
                <#--  BOTTOM PAGINATION CONTOL  -->
                <div class="paginatorContainer col-md-12 col-sm-12 col-xs-12" *ngIf="worksService.showPagination && !this.printView">
                    <mat-paginator 
                    [length]="worksService.paginationTotalAmountOfWorks"
                    [pageSize]="worksService.paginationBatchSize"
                    [pageSizeOptions]="[10, 50, 100]"
                    [pageIndex]="worksService.paginationIndex"
                    (page)="pageEvent($event)"
                    >
                    </mat-paginator>
                    <i class="glyphicon glyphicon-refresh spin x2 green" id="spinner" *ngIf="worksService?.loading"></i>
                </div>
            
            <div *ngIf="worksService?.loading == false && worksService?.groups?.length == 0">
                <strong>
                    ${springMacroRequestContext.getMessage("workspace_works_body_list.havenotaddedanyworks")} 
                    <a role="button" *ngIf="noLinkFlag" (click)="showWorkImportWizard()">${springMacroRequestContext.getMessage("workspace_works_body_list.addwork")}</a>
                    <span *ngIf="!noLinkFlag">${springMacroRequestContext.getMessage("workspace_works_body_list.addwork")}</span>
                </strong>
            </div>          
        </div>
    </div>
</script>