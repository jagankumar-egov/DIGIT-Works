package org.egov.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import org.springframework.validation.annotation.Validated;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

/**
 * FacilityRequest
 */
@Validated
@javax.annotation.Generated(value = "org.egov.codegen.SpringBootCodegen", date = "2022-12-08T16:20:57.141+05:30")

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FacilityRequest {
    @JsonProperty("RequestInfo")
    private RequestInfo requestInfo = null;

    @JsonProperty("Facility")
    @Valid
    private List<Facility> facility = new ArrayList<>();

    @JsonProperty("apiOperation")
    private ApiOperation apiOperation = null;


    public FacilityRequest addFacilityItem(Facility facilityItem) {
        this.facility.add(facilityItem);
        return this;
    }

}

