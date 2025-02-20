package org.orcid.core.oauth.openid;

import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.orcid.core.constants.OrcidOauth2Constants;
import org.orcid.core.manager.ClientDetailsEntityCacheManager;
import org.orcid.core.manager.ProfileEntityCacheManager;
import org.orcid.core.manager.read_only.PersonDetailsManagerReadOnly;
import org.orcid.jaxb.model.clientgroup.ClientType;
import org.orcid.jaxb.model.message.ScopePathType;
import org.orcid.jaxb.model.record_v2.Person;
import org.orcid.persistence.jpa.entities.ClientDetailsEntity;
import org.orcid.persistence.jpa.entities.ProfileEntity;
import org.orcid.pojo.ajaxForm.PojoUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.common.OAuth2AccessToken;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.security.oauth2.provider.token.TokenEnhancer;

import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.JWTClaimsSet.Builder;
import com.nimbusds.jwt.SignedJWT;
import com.nimbusds.oauth2.sdk.token.BearerAccessToken;
import com.nimbusds.openid.connect.sdk.claims.AccessTokenHash;

/**
 * This class creates and appends JWT id_tokens to the response.
 * 
 * @author tom
 *
 */
public class OpenIDConnectTokenEnhancer implements TokenEnhancer {

    @Value("${org.orcid.core.baseUri}")
    private String path;

    @Resource
    private ProfileEntityCacheManager profileEntityCacheManager;
    
    @Resource
    private PersonDetailsManagerReadOnly personDetailsManagerReadOnly;

    @Resource
    private ClientDetailsEntityCacheManager clientDetailsEntityCacheManager;

    @Resource
    private OpenIDConnectKeyService keyManager;
    
    @Value("${org.orcid.core.token.read_validity_seconds:631138519}")
    private int readValiditySeconds;

    @Override
    public OAuth2AccessToken enhance(OAuth2AccessToken accessToken, OAuth2Authentication authentication) {
        // We check for a nonce and max_age which are added back into request by
        // OrcidClientCredentialEndPointDelegatorImpl
        Map<String, String> params = authentication.getOAuth2Request().getRequestParameters();

        // only add if we're using openid scope.
        // only add in implicit flow if response_type id_token is present
        String scopes = params.get(OrcidOauth2Constants.SCOPE_PARAM);
        if (PojoUtil.isEmpty(scopes) || !ScopePathType.getScopesFromSpaceSeparatedString(scopes).contains(ScopePathType.OPENID)) {
            return accessToken;
        }
        // inject the OpenID Connect "id_token" (authn). This is distinct from
        // the access token (authz), so is for transporting info to the client
        // only
        // this means we do not have to support using them for authentication
        // purposes. Some APIs support it, but it is not part of the spec.
        try {
            String idTok = buildIdToken(accessToken, authentication.getName(), params.get(OrcidOauth2Constants.CLIENT_ID_PARAM),params.get(OrcidOauth2Constants.NONCE) );
            accessToken.getAdditionalInformation().put(OrcidOauth2Constants.ID_TOKEN, idTok);
        } catch (JOSEException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return accessToken;

    }

    public String buildIdToken(OAuth2AccessToken accessToken, String orcid, String clientID, String nonce) throws JOSEException {
        Builder claims = new JWTClaimsSet.Builder();
        claims.audience(clientID);
        claims.subject(orcid);   
        claims.issuer(path);
        claims.claim("at_hash", createAccessTokenHash(accessToken.getValue()));
        
        Date now = new Date();
        Calendar twentyFourHrs = Calendar.getInstance();
        twentyFourHrs.setTime(now);
        twentyFourHrs.add(Calendar.DAY_OF_YEAR, 1);
        
        claims.issueTime(now);
        claims.expirationTime(twentyFourHrs.getTime());
        
        claims.jwtID(UUID.randomUUID().toString());
        if (nonce != null)
            claims.claim(OrcidOauth2Constants.NONCE, nonce);
        
        ProfileEntity e = profileEntityCacheManager.retrieve(orcid);

        claims.claim(OrcidOauth2Constants.AUTH_TIME, e.getLastLogin());

        // If it is a member, include AMR
        ClientDetailsEntity c = clientDetailsEntityCacheManager.retrieve(clientID);

        if (StringUtils.isNotEmpty(c.getClientType()) && !ClientType.PUBLIC_CLIENT.equals(ClientType.valueOf(c.getClientType()))) {
            claims.claim(OrcidOauth2Constants.AUTHENTICATION_METHODS_REFERENCES, (e.getUsing2FA() ? OrcidOauth2Constants.AMR_MFA : OrcidOauth2Constants.AMR_PWD));
        }
        
        Person person = personDetailsManagerReadOnly.getPublicPersonDetails(orcid);
        if (person.getName() != null) {
            if (person.getName().getCreditName() != null) {
                claims.claim("name", person.getName().getCreditName().getContent());
            }
            if (person.getName().getFamilyName() != null) {
                claims.claim("family_name", person.getName().getFamilyName().getContent());
            }
            if (person.getName().getGivenNames() != null) {
                claims.claim("given_name", person.getName().getGivenNames().getContent());
            }
        }

        SignedJWT signedJWT = keyManager.sign(claims.build());
        return signedJWT.serialize();
    }

    /**
     * Access Token hash value. If the ID Token is issued with an access_token
     * in an Implicit Flow, this is REQUIRED, which is the case for this subset
     * of OpenID Connect. Its value is the base64url encoding of the left-most
     * half of the hash of the octets of the ASCII representation of the
     * access_token value, where the hash algorithm used is the hash algorithm
     * used in the alg Header Parameter of the ID Token's JOSE Header. For
     * instance, if the alg is RS256, hash the access_token value with SHA-256,
     * then take the left-most 128 bits and base64url-encode them. The at_hash
     * value is a case-sensitive string.
     * 
     * @param accessToken
     * @return
     */
    private String createAccessTokenHash(String accessToken) {
        return AccessTokenHash.compute(new BearerAccessToken(accessToken), JWSAlgorithm.RS256).toString();
    }
}
