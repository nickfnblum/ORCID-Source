<script type="text/ng-template" id="emails-form-ng2-template">
    <div [ngClass]="{'edit-record edit-record-emails' : popUp}" style="position: static">
        <div class="row" *ngIf="popUp">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <h1 class="lightbox-title pull-left">{{emailsEditText}}</h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 col-xs-12 col-sm-12" style="position: static">
                <table class="settings-table" style="position: static">
                    <tr>
                        <td colspan="2" [ngClass]="{'email-pop-up' : popUp}" style="border-top:0">
                            <h2>${springMacroRequestContext.getMessage("manage.email.my_email_addresses")}</h2>
                            <div class="editTablePadCell35">
                                <!-- Unverified set primary -->
                                <div class="grey-box" *ngIf="showUnverifiedEmailSetPrimaryBox">
                                    <h4><@orcid.msg 'workspace.your_primary_email_new' /></h4>
                                    <p><@orcid.msg 'workspace.youve_changed' /></p>
                                    <p><@orcid.msg 'workspace.you_need_to_verify' /></p>
                                    <p><@orcid.msg 'workspace.ensure_future_access2' /><br />
                                    <p><strong>{{primaryEmail}}</strong></p>
                                    <p><@orcid.msg 'workspace.ensure_future_access3' /> <a target="articles.149457" href="<@orcid.msg 'common.kb_uri_default'/>360006973793"><@orcid.msg 'workspace.ensure_future_access4' /></a> <@orcid.msg 'workspace.ensure_future_access5' /> <a target="common.contact_us.uri" href="<@orcid.msg 'common.contact_us.uri' />"><@orcid.msg 'common.contact_us.uri' /></a>.</p>
                                    <div class="topBuffer">
                                        <a (click)="closeUnverifiedEmailSetPrimaryBox()"><@orcid.msg 'freemarker.btnclose' /></a>
                                    </div>
                                </div>
                                <!-- Email table -->
                                <div class="table-responsive bottomBuffer" style="position: static">
                                    <table class="table" style="position: static">
                                    <ng-container *ngFor="let email of formData.emails | orderBy:'value'" >
                                        <tr class="data-row-group" name="email">
                                            <!-- Primary Email -->
                                            <td [ngClass]="{primaryEmail:email.primary}" class="col-md-3 col-xs-12 email">  
                                                <div *ngIf="email.edit === undefined || !email.edit">
                                                    <span>{{email.value}}</span>
                                                    <span (click)="emailEdit(email.value)"  role="Button" class="glyphicon glyphicon-pencil"  role="presentation" style="padding-left: 5px;"></span>
                                                </div>
                                                <div *ngIf="email.edit">
                                                    <input autofocus [(ngModel)]="emailEditingNewValue"  (keyup.enter)="emailEditSave()">
                                                    <br/>
                                                    <div  class="save-edit-button" (click)="emailEditSave(email)" style="padding-left: 5px; word-break: break-word;"> SAVE</div>
                                                    <div  class="cancel-edit-button" (click)="emailEditingCancel(email)" style="padding-left: 5px; word-break: break-word;"> CANCEL</div>
                                                </div>
                                                
                                                <span class="orcid-error small" *ngIf="TOGGLZ_HIDE_UNVERIFIED_EMAILS && !email.verified && !(email.visibility=='PRIVATE')">${springMacroRequestContext.getMessage("manage.email.only_verified")} ${springMacroRequestContext.getMessage("common.please")} <a (click)="verifyEmail(email, popUp)">${springMacroRequestContext.getMessage("manage.developer_tools.verify_your_email")}</a></span>
                                            </td>
                                            <td>                     
                                                <span *ngIf="!email.primary"> <a class="border-button" [ngClass]="{'disabled': !email.verified}"
                                                    (click)="setPrimary(email, email.verified)"
                                                    (mouseenter)="showTooltip(email.value)" 
                                                    (mouseleave)="hideTooltip(email.value)">${springMacroRequestContext.getMessage("manage.email.set_primary")} </a>
                                            
                                                    <div class="popover popover-tooltip bottom show-unverified-popover" *ngIf="showElement[email.value] && !email.verified">
                                                    <div class="arrow"></div><div class="popover-content">
                                                    <span>${springMacroRequestContext.getMessage("email.edit.unverified.popover")}</span>
                                                    </div>
                                                    </div>
                                                </span>

                                                <span *ngIf="email.primary" class="muted" class="border-button active">
                                                    ${springMacroRequestContext.getMessage("manage.email.primary_email")}
                                                </span>
                                            </td>
                                            <!-- 
                                            <td ng-init="emailStatusOptions = [{label:'<@orcid.msg "manage.email.current.true" />',val:true},{label:'<@orcid.msg "manage.email.current.false" />',val:false}];"> 
                                            -->
            
                                            <td class="email-verified">
                                                <span *ngIf="!email.verified" class="left">
                                                    <a class="border-button" (click)="verifyEmail(email, popUp)">${springMacroRequestContext.getMessage("manage.email.verify")}</a>
                                                </span>
                                                <span *ngIf="email.verified" class="border-button active">
                                                    ${springMacroRequestContext.getMessage("manage.email.verified")}
                                                </span>
                                            </td>   
                                            <td>            
                                                <select 
                                                    [(ngModel)]="email.current" 
                                                    (ngModelChange)="saveEmail(false)"
                                                >
                                                    <option 
                                                        *ngFor="let emailStatusOption of emailStatusOptions"
                                                        [value]="emailStatusOption.val"
                                                    >
                                                        {{emailStatusOption.label}}   
                                                    </option>        
                                                </select>
                                            </td>
                                            <td width="26" class="tooltip-container">                                      
                                                <a name="delete-email-inline" class="glyphicon glyphicon-trash grey"
                                                    *ngIf="email.primary == false"
                                                    (click)="confirmDeleteEmailInline(email, $event)" >
                                                </a>
                                            </td>
                                            <td width="100" style="padding-top: 0; position: static">
                                                <div class="emailVisibility" style="float: right; position: static">
                                                    <privacy-toggle-ng2 
                                                    [dataPrivacyObj]="email" 
                                                    (privacyUpdate)="privacyChange($event, email)"
                                                    elementId="email-privacy-toggle" 
                                                    >    
                                                    </privacy-toggle-ng2>
                        
                                                </div>
                                            </td>
                                        
                                        </tr>
                                            
                                        <tr *ngIf="emailEditingErrors && emailEditing === email.value"  style="height: 50px;">                       
                                                <span style="padding-left: 5px; width: 250%;" class="orcid-error" *ngFor="let error of emailEditingErrors"  [innerHTML]="error"></span>
                                        </tr>
                                    </ng-container>
                                    </table>            
                                    <!-- Delete Email Box -->
                                    <div  class="delete-email-box grey-box" *ngIf="showDeleteBox">               
                                        <div style="margin-bottom: 10px;">
                                            <@orcid.msg 'manage.email.pleaseConfirmDeletion' /> {{emailService.delEmail.value}}
                                        </div>
                                        <div>
                                            <ul class="pull-right inline-list">
                                                <li><a (click)="closeDeleteBox()"><@orcid.msg 'freemarker.btncancel' /></a></li>
                                                <li><button class="btn btn-danger" (click)="deleteEmailInline(delEmail)"><@orcid.msg 'manage.email.deleteEmail' /></button></li>                     
                                            </ul>
                                        </div>
                                    </div>
                                    <!-- Email confirmation -->
                                    <div *ngIf="showEmailVerifBox" class="verify-email-box grey-box bottomBuffer">                  
                                        <div>
                                            <p><strong><@orcid.msg 'manage.email.verificationEmail'/> {{verifyEmailObject.value}}</strong><br>
                                            <@orcid.msg 'workspace.check_your_email'/></p>
                                        </div>
                                        <div class="clearfix">
                                            <ul class="pull-right inline-list">
                                                <li><a (click)="closeVerificationBox()"><@orcid.msg 'freemarker.btnclose'/></a></li>
                                            </ul>
                                        </div>
                                    </div>              
                                </div>
                                <div id="addEmailNotAllowed" *ngIf="isPassConfReq" >
                                    ${springMacroRequestContext.getMessage("manage.add_another_email.not_allowed")}
                                </div>  
                                <!--Add email-->        
                                <div *ngIf="formData?.emails?.length < MAX_EMAIL_COUNT && !isPassConfReq">
                                    <div class="add-email">
                                        <label hidden for="addEmail">${springMacroRequestContext.getMessage("manage.add_another_email")}</label>
                                        <input type="email" name="addEmail" id="addEmail" placeholder="${springMacroRequestContext.getMessage("manage.add_another_email")}"
                                        (keyup.enter)="checkCredentials(popUp)" class="input-xlarge inline-input" [(ngModel)]="inputEmail.value" required/>
                                        <span (click)="checkCredentials(popUp)" class="btn btn-primary">${springMacroRequestContext.getMessage("manage.spanadd")}</span>       
                                        <span class="orcid-error"
                                            *ngIf="inputEmail?.errors?.length > 0"> <span
                                            *ngFor='let error of inputEmail.errors'
                                            [innerHTML]="error"></span>
                                        </span>  
                                    </div>              
                                    <p>
                                        <small class="italic">
                                        ${springMacroRequestContext.getMessage("manage.verificationEmail.1")} <a href="{{aboutUri}}/content/orcid-terms-use" target="manage.verificationEmail.2">${springMacroRequestContext.getMessage("manage.verificationEmail.2")}</a>${springMacroRequestContext.getMessage("manage.verificationEmail.3")}
                                        </small>
                                    </p>             
                                </div>
                                <div  class="confirm-password-box grey-box" *ngIf="popUp && showConfirmationBox">
                                    <div style="margin-bottom: 10px;">
                                        <@orcid.msg 'check_password_modal.confirm_password' />  
                                    </div>
                                    <div>
                                        <label for=""><@orcid.msg 'check_password_modal.password' /></label>:   
                                                       
                                        <input id="check_password_modal.password" type="password" name="check_password_modal.password" [(ngModel)]="password" (keyup.enter)="submitModal()"/>
                                        
                                    </div>                  
                                    <div>
                                        <ul class="pull-right inline-list">
                                            <li><a (click)="closeModal()"><@orcid.msg 'check_password_modal.close'/></a></li>
                                            <li><button id="bottom-submit" class="btn btn-primary" (click)="submitModal()"><@orcid.msg 'check_password_modal.submit'/></button></li>
                                        </ul>   
                                    </div>
                                </div>
                            </div>
                            <#if springMacroRequestContext.requestUri?contains("/account") >
                                <div id="emailFrequency" class="bottomBuffer">
                                    <h2><@orcid.msg 'manage.email.email_frequency.notifications.header' /></h2>
                                    <div class="editTablePadCell35">
                                        <p><@orcid.msg 'manage.email.email_frequency.notifications.1' /></p>
                                        <p><@orcid.msg 'manage.email.email_frequency.notifications.2' /></p>
                                        <p><@orcid.msg 'manage.email.email_frequency.notifications.selectors.header' /></p>                                            
                                        <div *ngIf="emailFrequencyOptions" class="control-group">
                                            <label for="amend-frequency"><@orcid.msg 'manage.email.email_frequency.notifications.selectors.amend' /></label><br>
                                            <select id="amend-frequency" name="amend-frequency" [(ngModel)]="sendChangeNotifications" (ngModelChange)="updateChangeNotificationsFrequency()">   
                                                <option *ngFor="let key of emailFrequencyOptions.emailFrequencyKeys" [value]="key">{{emailFrequencyOptions.emailFrequencies[key]}}</option>
                                            </select>
                                        </div>
                                        <div *ngIf="emailFrequencyOptions" class="control-group">
                                            <label for="administrative-frequency"><@orcid.msg 'manage.email.email_frequency.notifications.selectors.administrative' /></label><br>
                                            <select id="administrative-frequency" name="administrative-frequency" [(ngModel)]="sendAdministrativeChangeNotifications" (ngModelChange)="updateAdministrativeChangeNotificationsFrequency()">   
                                                <option *ngFor="let key of emailFrequencyOptions.emailFrequencyKeys" [value]="key">{{emailFrequencyOptions.emailFrequencies[key]}}</option>
                                            </select>
                                        </div>
                                        <div *ngIf="emailFrequencyOptions" class="control-group">
                                            <label for="permission-frequency"><@orcid.msg 'manage.email.email_frequency.notifications.selectors.permission' /></label><br>                  
                                            <select id="permission-frequency" name="permission-frequency" [(ngModel)]="sendMemberUpdateRequestsNotifications" (ngModelChange)="updateMemberUpdateRequestsFrequency()">   
                                                <option *ngFor="let key of emailFrequencyOptions.emailFrequencyKeys" [value]="key">{{emailFrequencyOptions.emailFrequencies[key]}}</option>
                                            </select>
                                        </div>
                                    </div> 
                                    <h2><@orcid.msg 'manage.email.email_frequency.news.header' /></h2>
                                    <div class="alert" *ngIf="!emailService?.primaryEmail?.verified && sendQuarterlyTips">
                                        <p><strong><@orcid.msg 'manage.email.email_frequency.news.unverified_1' /></strong><br> <@orcid.msg 'manage.email.email_frequency.news.unverified_2' /> <a (click)="verifyEmail(emailService.primaryEmail, popUp, 'newsTips')"><@orcid.msg 'manage.email.email_frequency.news.unverified_3'/></a>

                                    </div>
                                    <div *ngIf="showEmailVerifBoxNewsTips" class="verify-email-box grey-box bottomBuffer">                  
                                        <div>
                                            <p><strong><@orcid.msg 'manage.email.verificationEmail'/> {{verifyEmailObject.value}}</strong><br>
                                            <@orcid.msg 'workspace.check_your_email'/></p>
                                        </div>
                                        <div class="clearfix">
                                            <ul class="pull-right inline-list">
                                                <li><a (click)="closeVerificationBox('newsTips')"><@orcid.msg 'freemarker.btnclose'/></a></li>
                                            </ul>
                                        </div>
                                    </div> 
                                    <div class="editTablePadCell35">
                                        <div class="control-group">
                                            <input id="send-orcid-news" type="checkbox" name="sendOrcidNews" [(ngModel)]="sendQuarterlyTips" (ngModelChange)="updateSendQuarterlyTips()"/>
                                            <label for="send-orcid-news">
                                            <@orcid.msg 'manage.email.email_frequency.notifications.news.checkbox.label' /></label>
                                        </div>
                                    </div>
                                    <p><small class="italic"><@orcid.msg 'manage.email.email_frequency.bottom' /> <a href="https://orcid.org/privacy-policy#How_we_use_information" target="_blank"><@orcid.msg 'public-layout.privacy_policy' /></a></small></p>  
                                </div>
                            </#if>                                                            
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="row" *ngIf="popUp">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <a (click)="closeEditModal()" class="cancel-option pull-right"><@orcid.msg 'manage.email.close' /></a>
            </div>
        </div>
    </div>
</script>