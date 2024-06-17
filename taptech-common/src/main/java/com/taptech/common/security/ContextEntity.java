package com.taptech.common.security;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.*;
import org.springframework.data.annotation.*;
import org.springframework.data.redis.core.index.Indexed;

import javax.validation.constraints.NotNull;
import java.util.Collection;
import java.util.Date;


@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@JsonIdentityInfo(
		generator = ObjectIdGenerators.PropertyGenerator.class,
		property = "id")
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class ContextEntity {
	@Id
	private String id;

	@NotNull
	@Indexed
	private String contextId;

	@NotNull
	private String contextName;
	private String description;
	private String name;
	private boolean enabled = Boolean.TRUE.booleanValue();
	@NotNull
	private Collection<String> permissions;
	@NotNull

	//@JsonIdentityReference(alwaysAsId = false)
	@Reference
	private Collection<RoleEntity> roles;
	private String transactionId;
	@CreatedBy
	//@NotNull
	private String createdBy;
	@LastModifiedBy
	//@NotNull
	private String lastModifiedBy;
	//@CreatedDate
	private Date createdDate;
	@LastModifiedDate
	private Date lastModifiedByDate;


}
