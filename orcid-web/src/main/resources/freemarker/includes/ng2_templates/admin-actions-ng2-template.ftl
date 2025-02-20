<#include "/includes/ng2_templates/convert-client-confirm-ng2-template.ftl">
<#include "/includes/ng2_templates/move-client-confirm-ng2-template.ftl">

<script type="text/ng-template" id="admin-actions-ng2-template">
<!-- Switch user -->
<div class="workspace-accordion-item" id="switch-user">
    <p>
        <a *ngIf="showSwitchUser" (click)="showSwitchUser = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.switch_user' /></a>
        <a *ngIf="!showSwitchUser" (click)="showSwitchUser = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.switch_user' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" id="switch_user_section" *ngIf="showSwitchUser">
        <div class="form-group">
            <label for="orcidOrEmail"><@orcid.msg 'admin.switch_user.orcid.label' /></label>
            <input type="text" id="orcidOrEmail" [(ngModel)]="switchId" (keyup.enter)="switchUser(switchId)" placeholder="<@orcid.msg 'admin.switch_user.orcid.placeholder' />" class="input-xlarge" />
            <span class="orcid-error" *ngIf="switchUserError">
                <@spring.message "orcid.frontend.web.invalid_switch_orcid"/>
            </span>    
        </div>
        <div class="controls save-btns pull-left">
            <span id="switch-user" (click)="switchUser(switchId)" class="btn btn-primary"><@orcid.msg 'admin.switch_user.button'/></span>                     
        </div>
    </div>  
</div>

<!-- Find ids -->
<div class="workspace-accordion-item" id="find-ids">    
    <p>
        <a *ngIf="showFindIds" (click)="showFindIds = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.find_ids' /></a>
        <a *ngIf="!showFindIds" (click)="showFindIds = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.find_ids' /></a>
    </p>                
    <div class="collapsible bottom-margin-small admin-modal" id="find_ids_section" *ngIf="showFindIds">
        <div class="form-group">
            <label for="emails"><@orcid.msg 'admin.find_ids.label' /></label>
            <input type="text" id="emails" (keyup.enter)="findIds()" [(ngModel)]="csvIdsOrEmails" placeholder="<@orcid.msg 'admin.find_ids.placeholder' />" class="input-xlarge" />
        </div>
        <div class="controls save-btns pull-left">
            <span id="find-ids" (click)="findIds()" class="btn btn-primary"><@orcid.msg 'admin.find_ids.button'/></span>                       
        </div>
    </div>  
    <div class="form-group" *ngIf="showIds">
        <h3><@orcid.msg 'admin.find_ids.results'/></h3>
        <div *ngIf="profileList?.length > 0">
            <table class="table table-bordered table-hover">
                <tr>
                    <td><strong><@orcid.msg 'admin.email'/></strong></td>
                    <td><strong><@orcid.msg 'admin.orcid'/></strong></td>
                    <td><strong><@orcid.msg 'admin.account_status'/></strong></td>
                </tr>
                <tr *ngFor="let profile of profileList">
                    <td>{{profile.email}}</td>
                    <td><a href="<@orcid.msg 'admin.public_view.click.link'/>{{profile.orcid}}" target="profile.orcid">{{profile.orcid}}</a>&nbsp;(<@orcid.msg 'admin.switch.click.1'/>&nbsp;<a (click)="switchUser(profile.orcid)"><@orcid.msg 'admin.switch.click.here'/></a>&nbsp;<@orcid.msg 'admin.switch.click.2'/>)</td>
                    <td>{{profile.status}}</td>
                </tr>
            </table>
            <div class="controls save-btns pull-right bottom-margin-small">
                <a href="" class="cancel-action" (click)="showIds = false" (click)="csvIdsOrEmails = ''"><@orcid.msg 'freemarker.btnclose'/></a>
            </div>
        </div>
        <div *ngIf="profileList?.length == 0">
            <span><@orcid.msg 'admin.find_ids.no_results'/></span>
        </div>
    </div>         
</div>

<!-- Reset password -->
<div class="workspace-accordion-item" id="reset-password">
    <p>
        <a *ngIf="showResetPassword" (click)="showResetPassword = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.reset_password' /></a>
        <a *ngIf="!showResetPassword" (click)="showResetPassword = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.reset_password' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showResetPassword">
        <div class="form-group">
            <label for="orcid"><@orcid.msg 'admin.reset_password.orcid.label' /></label>
            <input type="text" id="orcid" (keyup.enter)="confirmResetPassword()" [(ngModel)]="resetPasswordParams.orcidOrEmail" placeholder="<@orcid.msg 'admin.reset_password.orcid.placeholder' />" class="input-xlarge" (ngModelChange)="validateResetPassword()"/>
            <a href class="glyphicon glyphicon-ok green" *ngIf="emailAddressVerified"></a>
            <label for="password"><@orcid.msg 'admin.reset_password.password.label' /></label>
            <input type="text" id="password" (keyup.enter)="confirmResetPassword()" [(ngModel)]="resetPasswordParams.password" placeholder="<@orcid.msg 'admin.reset_password.password.placeholder' />" class="input-xlarge" />
            <a (click)="randomString()" class="glyphicon glyphicon-random blue"></a>
            <div *ngIf="showResetPasswordMessages">
                <div *ngIf="resetPasswordParams?.error != null">
                    <span class="orcid-error">{{resetPasswordParams.error}}</span>
                </div>
                <div *ngIf="resetPasswordSuccess">
                    <span class="orcid-error"><@orcid.msg 'deprecate_orcid_confirmation_modal.heading' /></span>
                </div>
            </div>
        </div>
        <div class="controls save-btns pull-left" *ngIf="!showResetPasswordConfirm">
            <span (click)="confirmResetPassword()" class="btn btn-primary"><@orcid.msg 'admin.reset_password.button'/></span>                        
        </div>
        <div class="controls save-btns pull-left" *ngIf="showResetPasswordConfirm">
            <label class="orcid-error"><@orcid.msg 'admin.reset_password.confirm.message'/> {{resetPasswordParams.orcidOrEmail}}?</label><br>
            <span (click)="resetPassword()" class="btn btn-primary"><@orcid.msg 'change_password.confirmnewpassword'/></span>&nbsp; 
            <a href="" class="cancel-action" (click)="showResetPasswordConfirm = false" (click)="resetPasswordParams.orcidOrEmail = ''" (click)="resetPasswordParams.password = ''" (click)="showResetPassword = false"><@orcid.msg 'freemarker.btncancel'/></a>
        </div>    
    </div>
</div>

<!-- Add Email to record -->
<div class="workspace-accordion-item" id="reactivate-record">
    <p>
        <a *ngIf="showAddEmailToRecord" (click)="showAddEmailToRecord = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.profile_add_email' /></a>
        <a *ngIf="!showAddEmailToRecord" (click)="showAddEmailToRecord = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.profile_add_email' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showAddEmailToRecord">    
        <div class="form-group">
            <label for="orcidId"><@orcid.msg 'admin.profile_add_email.to_add_email' /></label>
            <input type="text" id="orcidId" (keyup.enter)="showAddEmailToRecordConfirm = true" [(ngModel)]="elementAddEmailToRecord.orcid" placeholder="<@orcid.msg 'admin.profile_add_email.placeholder.to_add_email' />" class="input-xlarge" />
        </div>
        <div class="form-group">
            <label for="email"><@orcid.msg 'admin.profile_add_email.email' /></label>
            <input type="text" id="email" (keyup.enter)="showAddEmailToRecordConfirm = true" [(ngModel)]="elementAddEmailToRecord.email" placeholder="<@orcid.msg 'admin.profile_add_email.placeholder.email' />" class="input-xlarge" />
        </div>
        <div *ngIf="showAddEmailToRecordMessages">
            <div *ngIf="elementAddEmailToRecord.errors?.length > 0">
                <span class="orcid-error" *ngFor='let error of elementAddEmailToRecord.errors' [innerHTML]="error"></span><br />
            </div>
            <div *ngIf="!elementAddEmailToRecord.errors?.length">
                <@orcid.msg 'admin.add_email_sucess' />
            </div>
        </div>
        <div class="controls save-btns pull-left" *ngIf="!showAddEmailToRecordConfirm">
            <span id="deactivate-btn" (click)="showAddEmailToRecordConfirm = true" class="btn btn-primary"><@orcid.msg 'admin.profile_add_email.reactivate_account'/></span>                       
        </div>
        <div class="controls save-btns pull-left" *ngIf="showAddEmailToRecordConfirm">
            <label class="orcid-error"><@orcid.msg 'admin.profile_add_email.confirm.message'/> {{elementAddEmailToRecord.orcid}}?</label><br>
            <span (click)="addEmailToRecord()" class="btn btn-primary"><@orcid.msg 'admin.profile_add_email.reactivate_account'/></span>&nbsp; 
            <a href="" class="cancel-action" (click)="showAddEmailToRecordConfirm = false" ><@orcid.msg 'freemarker.btncancel'/></a>
        </div> 
    </div>
</div>

<!-- Verify email -->
<div class="workspace-accordion-item" id="verify-email">
    <p>
        <a *ngIf="showVerifyEmail" (click)="showVerifyEmail = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.verify_email' /></a>
        <a *ngIf="!showVerifyEmail" (click)="showVerifyEmail = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.verify_email' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showVerifyEmail">
        <div class="form-group">            
            <label for="email"><@orcid.msg 'admin.verify_email.title' /></label>
            <input type="text" (keyup.enter)="verifyEmail()" [(ngModel)]="emailToVerify" placeholder="<@orcid.msg 'admin.verify_email.placeholder' />" class="input-xlarge" />                                                                                    
        </div>
        <div *ngIf="verifyEmailMessage != null && verifyEmailMessageShowMessages">
            <span class="orcid-error" [innerHTML]="verifyEmailMessage"></span>
        </div>
        <div class="controls save-btns pull-left">
            <span id="verify-email" (click)="verifyEmail()" class="btn btn-primary"><@orcid.msg 'admin.verify_email.btn'/></span>                      
        </div>        
    </div>
</div>

<!-- Admin delegates -->
<div class="workspace-accordion-item" id="add-delegates">
    <p>
        <a *ngIf="showAddDelegates" (click)="showAddDelegates = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.delegate' /></a>
        <a *ngIf="!showAddDelegates" (click)="showAddDelegates = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.delegate' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showAddDelegates">
        <!-- Managed -->
        <div class="form-group">
            <label for="managed"><@orcid.msg 'admin.delegate.managed.label' /></label>
            <input type="text" id="managed" [(ngModel)]="addDelegateParams.managed.value" (keyup.enter)="addDelegate()" placeholder="<@orcid.msg 'admin.delegate.managed.placeholder' />" class="input-xlarge" (ngModelChange)="checkClaimedStatus('managed')">
            <a href class="glyphicon glyphicon-ok green" *ngIf="managedVerified"></a>
            <div id="invalid-managed" *ngIf="addDelegateParams.managed.errors.length > 0">
                <span class="orcid-error" *ngFor='let error of addDelegateParams.managed.errors' [innerHTML]="error"></span><br />
            </div>                          
        </div>              
        <!-- Trusted -->
        <div class="form-group">
            <label for="trusted"><@orcid.msg 'admin.delegate.trusted.label' /></label>
            <input type="text" id="trusted" [(ngModel)]="addDelegateParams.trusted.value" (keyup.enter)="addDelegate()" placeholder="<@orcid.msg 'admin.delegate.trusted.placeholder' />" class="input-xlarge"  (ngModelChange)="checkClaimedStatus('trusted')">
            <a href class="glyphicon glyphicon-ok green" *ngIf="trustedVerified"></a>
            <div id="invalid-trusted" *ngIf="addDelegateParams.trusted.errors.length > 0">
                <span class="orcid-error" *ngFor='let error of addDelegateParams.trusted.errors' [innerHTML]="error"></span><br />
            </div>                          
        </div>
        <div *ngIf="showAddDelegatesMessages">
            <div *ngIf="addDelegateParams.successMessage">
                <span class="orcid-error" [innerHTML]="addDelegateParams.successMessage"></span>
            </div>
            <div *ngIf="addDelegateParams.errors?.length > 0">
                <span class="orcid-error" *ngFor='let error of addDelegateParams.errors' [innerHTML]="error"></span><br />
            </div>
        </div>
        <div class="controls save-btns pull-left">
            <span id="bottom-confirm-delegate-profile" (click)="addDelegate()" class="btn btn-primary"><@orcid.msg 'admin.delegate.button'/></span>
        </div>
    </div>
</div>

<!-- Deprecate record -->
<div class="workspace-accordion-item" id="deprecate-record">
    <p>
        <a *ngIf="showDeprecateRecord" (click)="showDeprecateRecord = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.profile_deprecation' /></a>
        <a *ngIf="!showDeprecateRecord" (click)="showDeprecateRecord = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.profile_deprecation' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showDeprecateRecord">
        <!-- Deprecated -->
        <div class="form-group">
            <label for="deprecated"><@orcid.msg 'admin.profile_deprecation.to_deprecate' /></label>
            <input type="text" id="deprecated" [(ngModel)]="deprecateRecordParams.deprecatedAccount.orcid" (keyup.enter)="confirmDeprecate()" placeholder="<@orcid.msg 'admin.profile_deprecation.placeholder.account_to_deprecate' />" class="input-xlarge">                                   
            <div *ngIf="deprecateRecordParams.deprecatedAccount.errors?.length > 0 && showDeprecateRecordMessages">
                <span class="orcid-error" *ngFor='let error of deprecateRecordParams.deprecatedAccount.errors' [innerHTML]="error"></span><br />
            </div>
        </div>              
        <!-- Primary -->
        <div class="form-group">
            <label for="primary"><@orcid.msg 'admin.profile_deprecation.primary' /></label>
            <input type="text" id="primary" [(ngModel)]="deprecateRecordParams.primaryAccount.orcid" (keyup.enter)="confirmDeprecate()" placeholder="<@orcid.msg 'admin.profile_deprecation.placeholder.primary_account' />" class="input-xlarge">                                    
            <div *ngIf="deprecateRecordParams.primaryAccount.errors?.length > 0 && showDeprecateRecordMessages">
                <span class="orcid-error" *ngFor='let error of deprecateRecordParams.primaryAccount.errors' [innerHTML]="error"></span><br />
            </div>
        </div>        
        <div class="controls save-btns pull-left" *ngIf="!showDeprecateRecordConfirm">
            <span id="bottom-confirm-deprecate-record" (click)="confirmDeprecate()" class="btn btn-primary"><@orcid.msg 'admin.profile_deprecation.deprecate_account'/></span>
        </div>
        <br>
        <div class="form-group" *ngIf="deprecateRecordParams.successMessage != null && deprecateRecordParams.successMessage != '' && showDeprecateRecordMessages">
            <h3><@orcid.msg 'admin.success'/></h3>
            <p id="success-message">{{deprecateRecordParams.successMessage}}</p>  
            <div class="control-group">
                <a href="" class="cancel-action" (click)="deprecateRecordReset();"><@orcid.msg 'freemarker.btnclose'/></a>
            </div>  
        </div>
        <div class="form-group" *ngIf="showDeprecateRecordConfirm">
            <h3><@orcid.msg 'admin.profile_deprecation.deprecate_account.confirm'/></h3>
            <div class="bottom-margin-small">
                <p><@orcid.msg 'admin.profile_deprecation.deprecate_account.confirm.message.1'/></p>
                <table border="0">
                    <tr>
                        <td><strong><@orcid.msg 'admin.profile_deprecation.orcid'/></strong></td>
                        <td>{{deprecateRecordParams.deprecatedAccount.orcid}}</td>
                    </tr>
                    <tr>
                        <td><strong><@orcid.msg 'admin.profile_deprecation.name'/></strong></td>
                        <td>{{deprecateRecordParams.deprecatedAccount.givenNames}}&nbsp;{{deprecateRecordParams.deprecatedAccount.familyName}}</td>
                    </tr>
                    <tr>
                        <td><strong><@orcid.msg 'admin.profile_deprecation.email'/></strong></td>
                        <td>{{deprecateRecordParams.deprecatedAccount.email}}</td>
                    </tr>           
                </table>
            </div>
            <div class="bottom-margin-small">       
                <p><@orcid.msg 'admin.profile_deprecation.deprecate_account.confirm.message.2'/></p>
                <table>
                    <tr>
                        <td><strong><@orcid.msg 'admin.profile_deprecation.orcid'/></strong></td>
                        <td>{{deprecateRecordParams.primaryAccount.orcid}}</td>
                    </tr>
                    <tr>
                        <td><strong><@orcid.msg 'admin.profile_deprecation.name'/></strong></td>
                        <td>{{deprecateRecordParams.primaryAccount.givenNames}}&nbsp;{{deprecateRecordParams.primaryAccount.familyName}}</td>
                    </tr>
                    <tr>
                        <td><strong><@orcid.msg 'admin.profile_deprecation.email'/></strong></td>
                        <td>{{deprecateRecordParams.primaryAccount.email}}</td>
                    </tr>       
                </table>
            </div>          
            <div class="control-group">
                <button class="btn btn-primary" id="bottom-deprecate-profile" (click)="deprecateRecord();"><@orcid.msg 'admin.profile_deprecation.deprecate_account'/></button>&nbsp;
                <a class="cancel-action" (click)="deprecateRecordReset();"><@orcid.msg 'freemarker.btnclose'/></a>
            </div>
        </div>        
    </div>
</div>

<!-- Deactivate record -->
<div class="workspace-accordion-item" id="deactivate-record">
    <p>
        <a *ngIf="showDeactivateRecord" (click)="showDeactivateRecord = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.profile_deactivation' /></a>
        <a *ngIf="!showDeactivateRecord" (click)="showDeactivateRecord = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.profile_deactivation' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showDeactivateRecord">
        <div *ngIf="showDeactivateRecordMessages">
            <div class="alert alert-success" *ngIf="deactivateResults.success?.length > 0"><@spring.message "admin.profile_deactivation.deactivation_success"/>
                <br>{{deactivateResults.success}}
            </div>
            <div class="alert alert-success" *ngIf="deactivateResults.alreadyDeactivated?.length > 0"><@spring.message "admin.profile_deactivation.already_deactivated"/>
                <br>{{deactivateResults.alreadyDeactivated}}
            </div>
            <div class="alert alert-success" *ngIf="deactivateResults.notFoundList?.length > 0"><@spring.message "admin.profile_deactivation.not_found"/>
                <br>{{deactivateResults.notFoundList}}
            </div>
            <div class="alert alert-success" *ngIf="deactivateResults.members?.length > 0"><@spring.message "admin.profile_deactivation.members"/>
                <br>{{deactivateResults.members}}
            </div>
        </div>
        <div class="form-group">
            <label for="orcidIds"><@orcid.msg 'admin.profile_deactivation.to_deactivate' /></label>
            <input type="text" id="orcidIds" (keyup.enter)="deactivateRecord()" [(ngModel)]="ids" placeholder="<@orcid.msg 'admin.profile_deactivation.placeholder.to_deactivate' />" class="input-xlarge" />
        </div>
        <div class="controls save-btns pull-left">
            <span id="deactivate-btn" (click)="deactivateRecord()" class="btn btn-primary"><@orcid.msg 'admin.profile_deactivation.deactivate_account'/></span>                       
        </div>
    </div>
</div>

<!-- Reactivate record -->
<div class="workspace-accordion-item" id="reactivate-record">
    <p>
        <a *ngIf="showReactivateRecord" (click)="showReactivateRecord = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.profile_reactivation' /></a>
        <a *ngIf="!showReactivateRecord" (click)="showReactivateRecord = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.profile_reactivation' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showReactivateRecord">    
        <div class="form-group">
            <label for="orcidId"><@orcid.msg 'admin.profile_reactivation.to_reactivate' /></label>
            <input type="text" id="orcidId" (keyup.enter)="showReactivateRecordConfirm = true" [(ngModel)]="elementToReactivate.orcid" placeholder="<@orcid.msg 'admin.profile_reactivation.placeholder.to_reactivate' />" class="input-xlarge" />
        </div>
        <div class="form-group">
            <label for="email"><@orcid.msg 'admin.profile_reactivation.primary_email' /></label>
            <input type="text" id="email" (keyup.enter)="showReactivateRecordConfirm = true" [(ngModel)]="elementToReactivate.email" placeholder="<@orcid.msg 'admin.profile_reactivation.placeholder.primary_email' />" class="input-xlarge" />
        </div>
        <div *ngIf="showReactivateRecordMessages">
            <div *ngIf="elementToReactivate.errors?.length > 0">
                <span class="orcid-error" *ngFor='let error of elementToReactivate.errors' [innerHTML]="error"></span><br />
            </div>
            <div *ngIf="elementToReactivate.status != null && elementToReactivate.status != ''">
                <span class="orcid-error">{{elementToReactivate.status}}</span><br />
            </div>
        </div>
        <div class="controls save-btns pull-left" *ngIf="!showReactivateRecordConfirm">
            <span id="deactivate-btn" (click)="showReactivateRecordConfirm = true" class="btn btn-primary"><@orcid.msg 'admin.profile_reactivation.reactivate_account'/></span>                       
        </div>
        <div class="controls save-btns pull-left" *ngIf="showReactivateRecordConfirm">
            <label class="orcid-error"><@orcid.msg 'admin.profile_reactivation.confirm.message'/> {{elementToReactivate.orcid}}?</label><br>
            <span (click)="reactivateRecord()" class="btn btn-primary"><@orcid.msg 'admin.profile_reactivation.reactivate_account'/></span>&nbsp; 
            <a href="" class="cancel-action" (click)="showReactivateRecordConfirm = false" (click)="resetPasswordParams.orcidOrEmail = ''" (click)="resetPasswordParams.password = ''" (click)="showResetPassword = false"><@orcid.msg 'freemarker.btncancel'/></a>
        </div> 
    </div>
</div>

<!-- Lock record -->
<div class="workspace-accordion-item" id="lock-record">
    <p>
        <a *ngIf="showLockRecord" (click)="showLockRecord = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.lock_profile' /></a>
        <a *ngIf="!showLockRecord" (click)="showLockRecord = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.lock_profile' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showLockRecord">
        <div *ngIf="showLockRecordMessages">
            <div class="alert alert-success" *ngIf="lockResults.notFound?.length > 0"><@spring.message "admin.profile_lock.not_found"/>
                <br>{{lockResults.notFound}}
            </div>
            <div class="alert alert-success" *ngIf="lockResults.alreadyLocked?.length > 0"><@spring.message "admin.profile_lock.already_locked"/>
                <br>{{lockResults.alreadyLocked}}
            </div>
            <div class="alert alert-success" *ngIf="lockResults.reviewed?.length > 0"><@spring.message "admin.profile_lock.reviewed"/>
                <br>{{lockResults.reviewed}}
            </div>
            <div class="alert alert-success" *ngIf="lockResults.successful?.length > 0"><@spring.message "admin.profile_lock.lock_success"/>
                <br>{{lockResults.successful}}
            </div>
            <div class="alert alert-success" *ngIf="lockResults.descriptionMissing?.length > 0">
            	<@spring.message "admin.profile_lock.missing_description"/>
            </div>
        </div>
        <div class="control-group">
            <label for="orcid_to_lock"><@orcid.msg 'admin.lock_profile.orcid_ids_or_emails' /></label>
            <div class="controls">
                <textarea id="orcid_to_lock" [(ngModel)]="lockRecordsParams.orcidsToLock" class="input-xlarge one-per-line" placeholder="<@orcid.msg 'admin.lock_profile.orcid_ids_or_emails' />" ></textarea>
                <select [(ngModel)]="lockRecordsParams.lockReason">
                    <option *ngFor="let reason of lockReasons" [value]="reason">{{reason}}</option>
                </select>
                <textarea id="lock_reason_description" [(ngModel)]="lockRecordsParams.description" class="input-xlarge one-per-line" placeholder="<@orcid.msg 'admin.lock_profile.lock_reason_description' />" ></textarea>
            </div>
            <span id="bottom-confirm-lock-profile" (click)="lockRecords()" class="btn btn-primary"><@orcid.msg 'admin.lock_profile.btn.lock'/></span>      
        </div>
    </div>
</div>

<!-- Unlock record -->
<div class="workspace-accordion-item" id="unlock-record">
    <p>
        <a *ngIf="showUnlockRecord" (click)="showUnlockRecord = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.unlock_profile' /></a>
        <a *ngIf="!showUnlockRecord" (click)="showUnlockRecord = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.unlock_profile' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showUnlockRecord">
        <div *ngIf="showUnlockRecordMessages">
            <div class="alert alert-success" *ngIf="unlockResults.notFound?.length > 0"><@spring.message "admin.profile_unlock.not_found"/>
                <br>{{unlockResults.notFound}}
            </div>
            <div class="alert alert-success" *ngIf="unlockResults.alreadyUnlocked?.length > 0"><@spring.message "admin.profile_unlock.already_unlocked"/>
                <br>{{unlockResults.alreadyUnlocked}}
            </div>
            <div class="alert alert-success" *ngIf="unlockResults.successful?.length > 0"><@spring.message "admin.profile_unlock.unlock_success"/>
                <br>{{unlockResults.successful}}
            </div>
        </div>
        <div class="form-group">
            <label for="orcid_to_unlock"><@orcid.msg 'admin.lock_profile.orcid_ids_or_emails' /></label>
            <input type="text" id="orcid_to_unlock" (keyup.enter)="unlockRecords()" [(ngModel)]="ids" placeholder="<@orcid.msg 'admin.lock_profile.orcid_ids_or_emails' />" class="input-xlarge" />
        </div>
        <div class="controls save-btns pull-left">
            <span id="bottom-confirm-lock-profile" (click)="unlockRecords()" class="btn btn-primary"><@orcid.msg 'admin.unlock_profile.btn.unlock'/></span>
        </div>        
    </div>
</div>

<!-- Review record -->
<div class="workspace-accordion-item" id="review-record">
    <p>
        <a *ngIf="showReviewRecord" (click)="showReviewRecord = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.review_profile' /></a>
        <a *ngIf="!showReviewRecord" (click)="showReviewRecord = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.review_profile' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showReviewRecord">
        <div *ngIf="showReviewRecordMessages">
            <div class="alert alert-success" *ngIf="reviewResults.notFound?.length > 0"><@spring.message "admin.profile_review.not_found"/>
                <br>{{reviewResults.notFound}}
            </div>
            <div class="alert alert-success" *ngIf="reviewResults.alreadyReviewed?.length > 0"><@spring.message "admin.profile_review.already_reviewed"/>
                <br>{{reviewResults.alreadyReviewed}}
            </div>
            <div class="alert alert-success" *ngIf="reviewResults.successful?.length > 0"><@spring.message "admin.profile_review.review_success"/>
                <br>{{reviewResults.successful}}
            </div>
        </div>
        <div class="form-group">
            <label for="orcid_to_review"><@orcid.msg 'admin.review_profile.orcid_ids_or_emails' /></label>
            <input type="text" id="orcid_to_review" (keyup.enter)="reviewRecords()" [(ngModel)]="ids" placeholder="<@orcid.msg 'admin.review_profile.orcid_ids_or_emails' />" class="input-xlarge" />
        </div>
        <div class="controls save-btns pull-left">
            <span id="bottom-confirm-review-record" (click)="reviewRecords()" class="btn btn-primary"><@orcid.msg 'admin.review_profile.btn.review'/></span>
        </div>        
    </div>
</div>

<!-- Unreview record -->
<div class="workspace-accordion-item" id="unreview-record">
    <p>
        <a *ngIf="showUnreviewRecord" (click)="showUnreviewRecord = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.unreview_profile' /></a>
        <a *ngIf="!showUnreviewRecord" (click)="showUnreviewRecord = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.unreview_profile' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showUnreviewRecord">
        <div *ngIf="showUnreviewRecordMessages">
            <div class="alert alert-success" *ngIf="unreviewResults.notFound?.length > 0"><@spring.message "admin.profile_unreview.not_found"/>
                <br>{{unreviewResults.notFound}}
            </div>
            <div class="alert alert-success" *ngIf="unreviewResults.alreadyUnreviewed?.length > 0"><@spring.message "admin.profile_unreview.already_unreviewed"/>
                <br>{{unreviewResults.alreadyUnreviewed}}
            </div>
            <div class="alert alert-success" *ngIf="unreviewResults.successful?.length > 0"><@spring.message "admin.profile_unreview.unreview_success"/>
                <br>{{unreviewResults.successful}}
            </div>
        </div>
        <div class="form-group">
            <label for="orcid_to_unreview"><@orcid.msg 'admin.review_profile.orcid_ids_or_emails' /></label>
            <input type="text" id="orcid_to_unreview" (keyup.enter)="unreviewRecords()" [(ngModel)]="ids" placeholder="<@orcid.msg 'admin.review_profile.orcid_ids_or_emails' />" class="input-xlarge" />
        </div>
        <div class="controls save-btns pull-left">
            <span id="bottom-confirm-unreview-record" (click)="unreviewRecords()" class="btn btn-primary"><@orcid.msg 'admin.unreview_profile.btn.unreview'/></span>
        </div>
    </div>
</div>

<!-- Lookup id or email -->
<div class="workspace-accordion-item" id="lookup-id-or-email">
    <p>
        <a *ngIf="showLookupIdOrEmail" (click)="showLookupIdOrEmail = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.lookup_id_email' /></a>
        <a *ngIf="!showLookupIdOrEmail" (click)="showLookupIdOrEmail = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.lookup_id_email' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showLookupIdOrEmail">
        <div class="form-group">
            <label for="orcid_to_unreview"><@orcid.msg 'admin.review_profile.orcid_ids_or_emails' /></label>
            <textarea style="height:300px; width: 800px;" id="orcid_to_unreview" (keyup.enter)="lookupIdOrEmails()" [(ngModel)]="csvIdsOrEmails" placeholder="<@orcid.msg 'admin.lookup_id_email.placeholder' />"></textarea>
        </div>
        <div class="controls save-btns pull-left bottomBuffer">
            <span id="bottom-confirm-lookup" (click)="lookupIdOrEmails()" class="btn btn-primary"><@orcid.msg 'admin.lookup_id_email.button'/></span>
        </div>        
        <div class="clearfix" *ngIf="idsString.length">
            <div>
                <textarea style="height:300px; width: 800px; resize: none;" readonly="readonly" [innerHTML]="idsString"></textarea><br>
                <div class="controls save-btns pull-left bottom-margin-small">
                    <a href="" class="cancel-action" (click)="noResults = false" (click)="idsString = ''" (click)="csvIdsOrEmails = ''" (click)="showLookupIdOrEmail = false"><@orcid.msg 'freemarker.btnclose'/></a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Turn off 2FA -->
<div class="workspace-accordion-item" id="disable-2FA">
    <p>
        <a *ngIf="showDisable2FA" (click)="showDisable2FA = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.disable_2fa.title' /></a>
        <a *ngIf="!showDisable2FA" (click)="showDisable2FA = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.disable_2fa.title' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showDisable2FA">
       <div>
            <div class="alert alert-success" *ngIf="disable2FAResults.notFound?.length > 0"><@spring.message "admin.disable_2fa.not_found"/>
                <br>{{disable2FAResults.notFound}}
            </div>
            <div class="alert alert-success" *ngIf="disable2FAResults.without2FAs?.length > 0"><@spring.message "admin.disable_2fa.no_action"/>
                <br>{{disable2FAResults.without2FAs}}
            </div>
            <div class="alert alert-success" *ngIf="disable2FAResults.disabledIds?.length > 0"><@spring.message "admin.disable_2fa.success"/>
                <br>{{disable2FAResults.disabledIds}}
            </div>
        </div>
        <div class="form-group">
            <label for="orcid_to_unreview"><@orcid.msg 'admin.reset_password.orcid.label' /></label>
            <input type="text" id="orcid_to_disable-2fa" (keyup.enter)="disable2FA()" [(ngModel)]="toDisableIdsOrEmails" placeholder="<@orcid.msg 'admin.lookup_id_emailFA.placeholder' />" class="input-xlarge" />
        </div>
        <div class="controls save-btns pull-left">
            <span id="bottom-disable-2fa" (click)="disable2FA()" class="btn btn-primary"><@orcid.msg 'admin.disable_2fa.disable_button_text'/></span>
        </div>
    </div>
</div>

<!-- Batch resend claim emails -->
<div class="workspace-accordion-item" id="resend-claim-email">
    <p>
        <a *ngIf="showResendClaimEmail" (click)="showResendClaimEmail = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.resend_claim.title' /></a>
        <a *ngIf="!showResendClaimEmail" (click)="showResendClaimEmail = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.resend_claim.title' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showResendClaimEmail">
        <div *ngIf="showResendClaimEmailMessages">
            <div class="alert alert-success" *ngIf="resendClaimResults.notFound?.length > 0"><@spring.message "admin.resend_claim.not_found"/>
                <br>{{resendClaimResults.notFound}}
            </div>
            <div class="alert alert-success" *ngIf="resendClaimResults.alreadyClaimed?.length > 0"><@spring.message "admin.resend_claim.already_claimed"/>
                <br>{{resendClaimResults.alreadyClaimed}}
            </div>
            <div class="alert alert-success" *ngIf="resendClaimResults.successful?.length > 0"><@spring.message "admin.resend_claim.sent_success"/>
                <br>{{resendClaimResults.successful}}
            </div>
        </div>
        <div class="form-group">
            <label for="orcid_to_unreview"><@orcid.msg 'admin.reset_password.orcid.label' /></label>
            <input type="text" id="orcid_to_unreview" (keyup.enter)="resendClaimEmail()" [(ngModel)]="ids" placeholder="<@orcid.msg 'admin.lookup_id_email.placeholder' />" class="input-xlarge" />
        </div>
        <div class="controls save-btns pull-left">
            <span id="bottom-confirm-unreview-record" (click)="resendClaimEmail()" class="btn btn-primary"><@orcid.msg 'resend_claim.resend_claim_button_text'/></span>
        </div>
    </div>
</div>

<!-- convert public client to member client -->
<div class="workspace-accordion-item" id="convert-client">
    <p>
        <a *ngIf="showConvertClient" (click)="showConvertClient = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.convert_client.title' /></a>
        <a *ngIf="!showConvertClient" (click)="showConvertClient = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.convert_client.title' /></a>
    </p>
    <div class="collapsible bottom-margin-small admin-modal" *ngIf="showConvertClient">
       <div>
            <div class="alert alert-success" *ngIf="convertClient.clientNotFound">
                <@spring.message "admin.convert_client.client_not_found"/>
            </div>
            <div class="alert alert-success" *ngIf="convertClient.groupIdNotFound">
                <@spring.message "admin.convert_client.group_id_not_found"/>
            </div>
            <div class="alert alert-success" *ngIf="convertClient.groupIdDeactivated">
                <@spring.message "admin.convert_client.group_id.invalid"/>
            </div>
            <div class="alert alert-success" *ngIf="convertClient.alreadyMember">
                <@spring.message "admin.convert_client.already_member"/>
            </div>	            
        </div>
        <div class="form-group">
            <label for="client_to_convert"><@orcid.msg 'admin.convert_client.client_id.label' /></label>
            <input type="text" id="client_to_convert" [(ngModel)]="convertClient.clientId" placeholder="<@orcid.msg 'admin.convert_client.client_id.placeholder' />" class="input-xlarge" />
        </div>
        <div class="form-group">
            <label for="client_group_id"><@orcid.msg 'admin.convert_client.group_id.label' /></label>
            <input type="text" id="client_group_id" (keyup.enter)="processClientConversion()" [(ngModel)]="convertClient.groupId" placeholder="<@orcid.msg 'admin.convert_client.group_id.placeholder' />" class="input-xlarge" />
        </div>
        <div class="controls save-btns pull-left">
            <span id="bottom-convert-client" (click)="processClientConversion()" class="btn btn-primary"><@orcid.msg 'admin.convert_client.convert_button_text'/></span>
        </div>
    </div>
</div>


<div class="workspace-accordion-item" id="move-client">
        <p>
            <a *ngIf="showMoveClient" (click)="showMoveClient = false"><span class="glyphicon glyphicon-chevron-down blue"></span><@orcid.msg 'admin.move_client.title' /></a>
            <a *ngIf="!showMoveClient" (click)="showMoveClient = true"><span class="glyphicon glyphicon-chevron-right blue"></span><@orcid.msg 'admin.move_client.title' /></a>
        </p>
        <div class="collapsible bottom-margin-small admin-modal" *ngIf="showMoveClient">
        <div>
                <div class="alert alert-success" *ngIf="moveClient.clientNotFound">
                    <@spring.message "admin.convert_client.client_not_found"/>
                    </div>
                    <div class="alert alert-success" *ngIf="moveClient.groupIdNotFound">
                        <@spring.message "admin.convert_client.group_id_not_found"/>
                    </div>
                    <div class="alert alert-success" *ngIf="moveClient.groupIdDeactivated">
                        <@spring.message "admin.convert_client.group_id.invalid"/>
                    </div>
                    <div class="alert alert-success" *ngIf="moveClient.alreadyMember !== undefined && !moveClient.alreadyMember">
                        <@spring.message "admin.convert_client.is_not_already_member"/>
                    </div>	   
                    <div class="alert alert-success" *ngIf="!moveClient.clientNotFound && !moveClient.clientDeactivated">
                        <@spring.message "admin.convert_client.is_not_active"/>
                    </div>	           
                </div>
            <div class="form-group">
                <label for="client_to_convert"><@orcid.msg 'admin.convert_client.client_id.label' /></label>
                <input type="text" id="client_to_convert" [(ngModel)]="moveClient.clientId" placeholder="<@orcid.msg 'admin.convert_client.client_id.placeholder' />" class="input-xlarge" />
            </div>
            <div class="form-group">
                <label for="client_group_id"><@orcid.msg 'admin.convert_client.group_id.label' /></label>
                <input type="text" id="client_group_id" (keyup.enter)="processClientMove()" [(ngModel)]="moveClient.groupId" placeholder="<@orcid.msg 'admin.convert_client.group_id.placeholder' />" class="input-xlarge" />
            </div>
            <div class="controls save-btns pull-left">
                <span id="bottom-convert-client" (click)="processClientMove()" class="btn btn-primary"><@orcid.msg 'admin.move_client.confirmation.button.label'/></span>
            </div>
        </div>
</div>
</script>

<modalngcomponent elementHeight="370" elementId="confirmConvertClient" elementWidth="400">
    <convert-client-confirm-ng2></convert-client-confirm-ng2>
</modalngcomponent>


<modalngcomponent elementHeight="370" elementId="confirmMoveClient" elementWidth="400">
    <move-client-confirm-ng2></move-client-confirm-ng2>
</modalngcomponent>
