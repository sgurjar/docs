~~~~
# check available SSIDs
$netsh wlan show networks

# assuming your's says "Google Starbucks"
# create a profile xml file

$cat c:\tmp\starbucks-wifi.xml
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
  <name>starbucks</name> <!-- arbitrary text -->
  <SSIDConfig>
    <SSID>
      <hex>476F6F676C6520537461726275636B73</hex> <!-- hex of name -->
      <name>Google Starbucks</name>
    </SSID>
  </SSIDConfig>
  <connectionType>ESS</connectionType>
  <connectionMode>manual</connectionMode>
  <autoSwitch>false</autoSwitch>
  <MSM>
    <security>
      <authEncryption>
        <authentication>open</authentication>
        <encryption>none</encryption>
        <useOneX>false</useOneX>
      </authEncryption>
    </security>
  </MSM>
    <!-- enable MAC randomization -->
  <MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3">
    <enableRandomization>true</enableRandomization>
    <randomizationSeed>465065441</randomizationSeed>
  </MacRandomization>
</WLANProfile>

# add profile
$netsh wlan add filename="c:\tmp\starbucks-wifi.xml"

# connect using profile
$netsh wlan connect profile "starbucks"

# when you are done
$netsh wlan disconnect

# delete the profile
netsh wlan delete profile "starbucks"
~~~~
