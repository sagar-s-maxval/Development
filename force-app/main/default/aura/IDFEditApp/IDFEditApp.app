<aura:application description="IDFEditApp" implements="force:appHostable,flexipage:availableForAllPageTypes,flexipage:availableForRecordHome,force:hasRecordId" access="global">
    <aura:attribute name="recordId" type="String"/>
    <c:cmpIDFEdit idfId="{!v.recordId}"/>
</aura:application>