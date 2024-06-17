package com.taptech.common.security.user;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;

import java.util.HashSet;
import java.util.Set;


@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class UserContextPermissions {
	protected String username;
	protected String userId;
	protected String contextId;
	protected String roleId;
	@Builder.Default
	protected Boolean enabled = Boolean.FALSE;
	@Builder.Default
	protected Set<String> permissions = new HashSet<>();

}
