{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../vars.nix;
  private_key = pkgs.writeText "transip_private_key" ''
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQD0+07yVXmdy4kJ
VB1h15tuY47VXZCwxfNoUic7nFjW1KCF6Uh4qhkzzpOefSo8mZKIeBqyYXlIGjCG
8gci/V1gs270f6BDQA+z8GVtMAJtLUFSHrH5XL7ZNRAkDvd834AysHuc699sU1D7
DtnD0LXY+P1zOltD1auGln3m6LOs39/jla77CNrYG3GCLHy1CzRI5NVm03ktc7GU
OgihHsOACvk5RnHFn3niI/X5nsxp2XP0eVXRIf4o9nz07/IvilZ8Y1GPu0NF5hH3
gMcabBcGvaGkSkUF4q935dIsCKvFE3OXB+UBOvMyprSijSxuFyE5ne7k0CX08oFo
Q/ccltkVAgMBAAECggEBAOsKyp3awEpS43Gd0Gr1T91Di+DOWmogIf7vA1FAGkRT
0IdqYOvUV0XLZvpioElwFpT0lriaqKAy8GgoggxiBlsnDMdsQ7kCF47OkKGHtGxH
RSqi5KKZB0qijI/sBCs8zGTVymOuMrhd345gmzIyZqZ7jcAmNzYIJP+GF9mZXfn3
GOd9hMtaTOhBfhAC5u+xyxklm7zQkcNlFi66/GLUdm16EgKZuyaa9avwpPPVKG9O
R+6kimlJ2UpTVmGRp8bLozVARc0QvYG+hYsZhABoIqfLWiqxg8ssPNoYK6p73YsI
TE4ixBXJlgdBnqOVyzJiBjunq87q7/Gu53aYSZdAzcECgYEA/QI2vUzFhZVJxIoG
qxqPPg6P9GsVGia1ak+zeGI3SMzDsFiRXMBkpRozOSHSzcJuN4pmSfilNJYyBOh4
Whg+IE02K+oPi5evX3hZ0TFbJH8d89HPeOgR+2vB4Gr+5Fj+Mzzsc+feWtSvqBfy
WvO6Sch9pStAbpM8i0wYMlALzT0CgYEA9+DMlccu+7aAYqDFpiSlwV6Sc2NqeVwy
sFvZkO4yrCjdrN43ey2ToolcrrizAOhau9YmtwHLaVVaLcAjCMbXb7m6N0l8Beft
65Q0fUaeI21jRKAzENrTHyGkKT6HL3d1hp0w4486uNprmL0KCXVsVbA9sZM6/MvO
scMGbvfWKLkCgYEAmm35f34Wqjy/NAmTnGivug8laujZjobGAMf5IafBWtwxLbhB
sb11MRlW3q54f0MIBzqgyNHN9NUgXsKOg198vDaktBU/u9KwJrPNDtTzbslwPNx5
qLDuGOpjAloMjtCLCDdNlEmY/RQIy68iLMXLlTGdD23g/B0+vT+LHVqieXkCgYEA
zrB1B0NSavNvtE3o4TPXvxjTt0Gji9SUM7gy/4WPXTyqMzYMPzruyu4NCWfbYxtc
ZRoZqCnn6koQauu2it/6zh+pJeaxct9E5VXsOrXCsTnKN3P5gMlml6PelcGcybir
l/bEyEsrJO6EH5UppF90WTMfDk39NsPe8xzy5V7lBYkCgYB3XRL/i8jNuihYCnqQ
ErpaoGYogt+/nTLbujZ7rO5GlSLp1bdvirYo2GizpfTW3GHkqqwn9cisYi4XxoyR
3TetSdNV+hoKxmnKT0VbEjoIDQ2S/UMQj4gIWpn4O1JY65mPe4n6LoW1XMdyCU6V
DtNTbUGVSf0qSlpKSAHqvIcjrw==
-----END PRIVATE KEY-----
  '';
in
{  
  #  security.acme = {
  #    acceptTerms = true;
  #    defaults = {
  #     email = vars.acmeMailaddress;
  #     dnsProvider = "transip";
  #     environmentFile = pkgs.writeText "transipEnvFile" ''
  #       TRANSIP_ACCOUNT_NAME = "nagelstyling"
  #       TRANSIP_PRIVATE_KEY_PATH = private_key
  #     '';
  #     enableDebugLogs = true;
  #    };
  #    certs."933knl" = {
  #     domain ="*.933k.nl";
  #    };
  #  };

#   networking.firewall = {
#     checkReversePath = "loose";
#     interfaces.eth0 = {
#       allowedTCPPorts = [ 80 ];
#     };
#   };

   services.nginx = {
     enable = true;
   };

}
