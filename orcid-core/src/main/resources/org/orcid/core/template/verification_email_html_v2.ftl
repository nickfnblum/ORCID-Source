<#--

    =============================================================================

    ORCID (R) Open Source
    http://orcid.org

    Copyright (c) 2012-2014 ORCID, Inc.
    Licensed under an MIT-Style License (MIT)
    http://orcid.org/open-source-license

    This copyright and license information (including a link to the full license)
    shall be included in its entirety in all copies or substantial portion of
    the software.

    =============================================================================

-->
<#import "email_macros.ftl" as emailMacros />
<#escape x as x?html>
<!DOCTYPE html>
<html>
	<head>
	<title>${subject}</title>
	</head>
	<body>
		<div  style="padding: 20px; padding-top: 10px; margin: auto;">
			<img src="https://orcid.org/sites/all/themes/orcid/img/orcid-logo.png" alt="ORCID.org"/>
		    <hr />
		    <p style="font-family: arial, helvetica, sans-serif; font-size: 15px; color: #494A4C;">
		        <#if isPrimary?? && isPrimary>
                    <@emailMacros.msg "email.verify.primary_reminder_v2" /><@emailMacros.space />
                </#if>
                <@emailMacros.msg "email.verify.thank_you_button" />
            </p>
				     <table
                        cellpadding="0"
                        cellspacing="0"
                        style="font-family: Helvetica, Arial, sans-serif;  border-spacing: 0px; border-collapse: separate !important; border-radius: 4px; margin: 0 auto; margin-top:20px"
                    >
                        <tbody>
                        <tr>
                            <td
                            style="border-spacing: 0px; border-collapse: collapse; line-height: 24px; font-size: 16px; border-radius: 4px; margin: 0;"
                            >
                            <a
                                id="verificationButton"
                                href="${verificationUrl}?lang=${locale}"
                                style="font-size: 20px; font-family: Helvetica, Arial, sans-serif; text-decoration: none; border-radius: 4.8px; line-height: 25px; display: inline-block; font-weight: normal; white-space: nowrap; background-color: #31789B; color: #ffffff; padding: 8px 16px; border: 1px solid #31789B;"
                                > <@emailMacros.msg "email.button" /></a
                            >
                            </td>
                        </tr>
                        </tbody>
                    </table>

                    <table
                        cellpadding="0"
                        cellspacing="0"
                        style="font-family: arial, helvetica, sans-serif; border-spacing: 0px; border-collapse: separate !important; border-radius: 4px; margin: 0 auto; "
                    >
                        <tbody>
                        <tr>
                            <td>
                            <p
                                align="center"
                                class="text-center"
                                style="line-height: 24px; font-size: 16px; margin: 0; padding-bottom: 30px; padding-top: 20px; word-break: break-word;"
                            >
                                <a
                                id="verificationUrl"
                                href="${verificationUrl}?lang=${locale}"
                                target="orcid.blank"
                                >${verificationUrl}?lang=${locale}</a
                                >
                            </p>
                            </td>
                        </tr>
                        </tbody>
                    </table>

		    <p style="font-family: arial, helvetica, sans-serif; font-size: 15px; color: #494A4C;">
		    	<@emailMacros.msg "email.verify.1" /><@emailMacros.space />${orcid}<@emailMacros.msg "email.verify.2" /><@emailMacros.space /><a href="${baseUri}/${orcid}?lang=${locale}" target="orcid.blank">${baseUri}/${orcid}</a><@emailMacros.space /><@emailMacros.msg "email.verify.primary_email_1" /><@emailMacros.space />${primaryEmail}<@emailMacros.msg "email.verify.primary_email_2" />.
		    </p>
			<#include "email_footer_html.ftl"/>
		 </div>
	 </body>
 </html>
 </#escape>
