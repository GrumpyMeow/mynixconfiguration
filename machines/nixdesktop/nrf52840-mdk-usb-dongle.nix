{ lib
, stdenv
, fetchFromGitHub
, python3
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "nrf52840-mdk";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "makerdiary";
    repo = "nrf52840-mdk-usb-dongle";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Zsf8AzBEVoiSjvDqOq3uqxDzRpZNoRcufTIX5v9ePOc=";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  nativeCheckInputs = [
    behave
    nose
  ];

  meta = with lib; {
    description = "nRF52840 MDK USB Dongle";
    homepage = "https://wiki.makerdiary.com/nrf52840-mdk-usb-dongle/";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
