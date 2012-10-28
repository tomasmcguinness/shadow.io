<?xml version="1.0" encoding="utf-8"?>
<serviceModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" name="Shadow.UShadow.Cloud" generation="1" functional="0" release="0" Id="c20ad092-6351-4b69-91ac-346d242c71c3" dslVersion="1.2.0.0" xmlns="http://schemas.microsoft.com/dsltools/RDSM">
  <groups>
    <group name="Shadow.UShadow.CloudGroup" generation="1" functional="0" release="0">
      <settings>
        <aCS name="Shadow.UShadow.Cloud.Worker:Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" defaultValue="">
          <maps>
            <mapMoniker name="/Shadow.UShadow.Cloud/Shadow.UShadow.CloudGroup/MapShadow.UShadow.Cloud.Worker:Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" />
          </maps>
        </aCS>
        <aCS name="Shadow.UShadow.Cloud.WorkerInstances" defaultValue="[1,1,1]">
          <maps>
            <mapMoniker name="/Shadow.UShadow.Cloud/Shadow.UShadow.CloudGroup/MapShadow.UShadow.Cloud.WorkerInstances" />
          </maps>
        </aCS>
      </settings>
      <maps>
        <map name="MapShadow.UShadow.Cloud.Worker:Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" kind="Identity">
          <setting>
            <aCSMoniker name="/Shadow.UShadow.Cloud/Shadow.UShadow.CloudGroup/Shadow.UShadow.Cloud.Worker/Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" />
          </setting>
        </map>
        <map name="MapShadow.UShadow.Cloud.WorkerInstances" kind="Identity">
          <setting>
            <sCSPolicyIDMoniker name="/Shadow.UShadow.Cloud/Shadow.UShadow.CloudGroup/Shadow.UShadow.Cloud.WorkerInstances" />
          </setting>
        </map>
      </maps>
      <components>
        <groupHascomponents>
          <role name="Shadow.UShadow.Cloud.Worker" generation="1" functional="0" release="0" software="F:\Development\shadow.io\code\server\Shadow.UShadow.Cloud\csx\Debug\roles\Shadow.UShadow.Cloud.Worker" entryPoint="base\x64\WaHostBootstrapper.exe" parameters="base\x64\WaWorkerHost.exe " memIndex="1792" hostingEnvironment="consoleroleadmin" hostingEnvironmentVersion="2">
            <settings>
              <aCS name="Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" defaultValue="" />
              <aCS name="__ModelData" defaultValue="&lt;m role=&quot;Shadow.UShadow.Cloud.Worker&quot; xmlns=&quot;urn:azure:m:v1&quot;&gt;&lt;r name=&quot;Shadow.UShadow.Cloud.Worker&quot; /&gt;&lt;/m&gt;" />
            </settings>
            <resourcereferences>
              <resourceReference name="DiagnosticStore" defaultAmount="[4096,4096,4096]" defaultSticky="true" kind="Directory" />
              <resourceReference name="EventStore" defaultAmount="[1000,1000,1000]" defaultSticky="false" kind="LogStore" />
            </resourcereferences>
          </role>
          <sCSPolicy>
            <sCSPolicyIDMoniker name="/Shadow.UShadow.Cloud/Shadow.UShadow.CloudGroup/Shadow.UShadow.Cloud.WorkerInstances" />
            <sCSPolicyUpdateDomainMoniker name="/Shadow.UShadow.Cloud/Shadow.UShadow.CloudGroup/Shadow.UShadow.Cloud.WorkerUpgradeDomains" />
            <sCSPolicyFaultDomainMoniker name="/Shadow.UShadow.Cloud/Shadow.UShadow.CloudGroup/Shadow.UShadow.Cloud.WorkerFaultDomains" />
          </sCSPolicy>
        </groupHascomponents>
      </components>
      <sCSPolicy>
        <sCSPolicyUpdateDomain name="Shadow.UShadow.Cloud.WorkerUpgradeDomains" defaultPolicy="[5,5,5]" />
        <sCSPolicyFaultDomain name="Shadow.UShadow.Cloud.WorkerFaultDomains" defaultPolicy="[2,2,2]" />
        <sCSPolicyID name="Shadow.UShadow.Cloud.WorkerInstances" defaultPolicy="[1,1,1]" />
      </sCSPolicy>
    </group>
  </groups>
</serviceModel>