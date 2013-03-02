Notes on Wireless Technologies
==============================

* __GSM__
An open, digital cellular technology used for transmitting mobile voice and data services
* __GPRS__
A very widely deployed wireless data service, available now with most GSM networks
* __EDGE__
GSM Evolution (EDGE) technology provides up to three times the data capacity of GPRS
* __WCDMA__
The air interface for one of the International Telecommunications Union's
family of third-generation (3G) mobile communications systems.
* __HSPA__
The set of technologies that enables operators to upgrade their existing
3G/WCDMA networks to carry more traffic and at faster speeds.
* __LTE__
Designed to be backwards-compatible with GSM and HSPA, Long Term Evolution
uses the OFDMA air interface, in combination with other technologies, to
offer high throughput speeds and high capacity.
* __GSM Roaming__
The ability for a customer to make and receive calls, send and receive
data, or access other services when travelling outside the coverage area of
their home network.

## Summary
* 1G Networks were analog, voice only systems
* 2G Networks introduced digital communication and capacity increases
    + GSM
    + Code Division Multiple Access
* 2.5G Networks extended the Internet to mobile devices
    + GPRS and EDGE for GSM networks
    + CDMA 1x for CDMA networks
* 3G Networks
    + GSM/UMTS used by AT&T and T-Mobile
    + CDMA and 1xEV-DO used by Sprint and Verizon

## -------
* In GSM/GPRS adjacent cells must use different frequencies.
* In CDMA networks, adjacent cells can use same frequencies.
* GSM divides a RF channel in 8 time slots, each can be used for a call.
  Time Division Multiple Access(TDMA)
* In CDMA rf channel is divided using orthogonal codes.
* Radio Frequency: Spectrum used for mobile radio signal divided in 2 directions-
    1. uplink and 
    2. downlink

## Acronyms
        3G      3rd Generation
        3GPP    3rd Generation Partnership
        AAA     Authentication, Authorization, and Accounting
        APN     Access Point Name
        ATM     Asynchronous Transfer Mode
        AuC     Authentication Center
        BCCH    Broadcast Control Channel
        BSC     Base Station Controller
        BSS     Base Station Subsystem
        BTS     Base Transceiver Station
        CAMEL   Customized Application for Mobile Enhanced Logic
        CDMA    Code Division Multiple Access
        CDR     Call Detail Record
        CPU     Central Processing Unit
        CRX     CDMA Roaming Exchange for 1x and 1xEV-DO
        CS-CN   Circuit Switched Core Network
        DNS     Domain Name Server
        EDGE    Enhanced Data rates for GSM Evolution
        EIR     Equipment Identity Register
        ESN     Equipment Serial Number
        FCC     Federal Communications Commission
        FDD     Frequency Division Duplex
        GGSN    Gateway GPRS Support Node
        GMSC    Gateway Mobile Switching Center
        GRX     GPRS Roaming Exchange
        GPRS    General Packet Radio Service
        GSM     Global System for Mobile Communications
        GTP     GPRS Tunneling Protocol
        HA      Home Agent
        HLR     Home Location Register
        HSDPA   High Speed Downlink Packet Access
        HSPA    High Speed Packet Access
        HSUPA   High Speed Uplink Packet Access
        HTTP    HyperText Transfer Protocol
        IMEI    International Mobile Equipment Identifier
        IMSI    International Mobile Subscriber Identity
        IP      Intelligent Peripherial
        IP      Internet Protocol
        ISUP    ISDN User Part
        IS-95   Interim Standard-95
        MAP     Mobile Application Part
        Mbps    Mega bits per second
        MDN     Mobile Directory Number
        MEID    Mobile Equipment Identity
        MGW     Media Gateway
        MHz     MegaHertz
        MIN     Mobile Identity Number
        MSC     Mobile Switching Center
        MSISDN  Mobile Subscriber ISDN Directory Number
        MSRN    Mobile Subscriber Routing Number
        OSS     Operations and Support Services
        PCF     Packet Control Function
        PDP     Packet Data Protocol
        PDSN    Packet Data Serving Node
        PS-CN   Packet Switched Core Network
        PSTN    Public Switched Telephone Network
        QoS     Quality of Service
        RAN     Radio Access Network
        RF      Radio Frequency
        RNC     Radio Network Controller
        RNS     Radio Network Subsystem
        SCP     Service Control Point
        SGSN    Serving GPRS Support Node
        SIM     Subscriber Identity Module
        SM-SC   Short Message-Service Center
        SMS     Short Message Service
        SS7     Signaling System 7
        STP     Signal Transfer Point
        TCP     Transmission Control Protocol
        TDM     Time Division Multiplexing
        TDMA    Time Division Multiple Access
        TMSI    Temporary Mobile Subscriber Identity
        UE      User Equipment
        UMTS    Universal Mobile Telecommunications System
        UTRAN   UMTS Terrestrial Radio Access Network
        WCDMA   Wideband Code Division Multiple Access
        VC      Virtual Channel
        VLR     Visiting Location Register
        VMS     Voice Mail System
        VP      Virtual Paths

## The Life of a Mobile
1. __Power On:__
    Searches for home network. Once it determines that it is in
    the home network it locks on it. If outside home network (roaming), try
    to determine roaming partner's network available.
    + Mobile want to select a cell site signal. Cell sites constantly 
    broadcast their system information as part of the general cell 
    broadcast. System information includes cell identity, neighboring
    cell details, timing information and synchronization information.
    Mobile try to decode best available signal, and select the cell site.
    + Once the cell site is selected, it perform registration with core 
    network beyond the radio network. Mobile coordinates with Base 
    Transceiver Station (BST) and Base Station Controller (BSC) in radio
    network to forward the registration request on the Mobile Switching 
    Center/Visiting Location Register (MSC/VLR). In addition to other 
    information registration message consists--
        - Internation Mobile Subscriber Identity (IMSI)
        - Precise cell and general location of mobile
        - Additionally, authentication information is exchanged to prove mobile's
        identity. (Authentication)
    + Once Visiting Location Register (VLR) receives the request, first it 
    checks to see if mobile is already known locally. If not, the VLR coordinate 
    with Home Location Register (HLR) to authenticate the mobile.
        - Request is passed over Signaling System 7 (SS7) network.
        - HLR verifies the mobile's subscription and returns authentication 
        variables for the VLR to authenticate the mobile. 
    + Once mobile is successfully authenticated, the subcriber's profile is 
    downloaded to the MSC/VLR.
    + As a part of this process HLR make a note of current location of the mobile.
    + Now mobile is ready to make and receive calls.
    + As mobile moves around cell site to cell site, the location update or 
    regsitration process is repeated as needed to keep the network informed about
    the mobile's current location. This occurs when the mobile moves out of the
    geographic area associted wtih one MSC and into the coverage area of another
    MSC.
2. Search for system to use
3. Receive System Broadcast Information
4. Register with the system
5. Make or receive calls
6. Power off or deregister with the system

## References
* [LTE Overview](http://masterltefaster.com/lte/overview.php)
* [Master LTE Faster](http://masterltefaster.com/)
* [Third Generation Partnership Project](http://3gpp.org)
* [Third Generation Partnership Project 2](http://www.3gpp2.org)
* [CDMA Development Group](http://www.cdg.org)
* [3G Americas](http://www.3gamericas.org)
* [4G Americas](http://www.4gamericas.org/)
* [CTIA - The Wireless Association](http://www.ctia.org)
* [Internet Engineering Task Force](http://www.ietf.org)
