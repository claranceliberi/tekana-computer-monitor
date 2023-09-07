package utils

import (
	"github.com/shirou/gopsutil/v3/host"
	"github.com/shirou/gopsutil/v3/net"
)

type SystemDetails struct {
	OS              string                  `json:"os"`
	Platform        string                  `json:"platform"`
	PlatformFamily  string                  `json:"platform_family"`
	PlatformVersion string                  `json:"platform_version"`
	HostName        string                  `json:"host_name"`
	BootTime        uint64                  `json:"boot_time"`
	IPAddresses     []string                `json:"ip_addresses"`
	MACAddresses    []string                `json:"mac_addresses"`
	NetInterfaces   net.InterfaceStatList 	`json:"net_interfaces"`
	SerialNumber    string                  `json:"serial_number"`
}

func GetSystemDetails() (SystemDetails, error) {
	var details SystemDetails

	// Fetching host related details
	hostInfo, err := host.Info()
	if err != nil {
		return details, err
	}

	details.OS = hostInfo.OS
	details.Platform = hostInfo.Platform
	details.PlatformFamily = hostInfo.PlatformFamily
	details.PlatformVersion = hostInfo.PlatformVersion
	details.HostName = hostInfo.Hostname
	details.BootTime = hostInfo.BootTime
	details.SerialNumber = hostInfo.HostID // This can be used as a serial number, but it's not the hardware serial number

	// Fetching network related details
	interfaces, err := net.Interfaces()
	if err != nil {
		return details, err
	}

	details.NetInterfaces = interfaces

	for _, iface := range interfaces {

		for _, addr := range iface.Addrs {
			details.IPAddresses = append(details.IPAddresses, addr.Addr)
		}
		details.MACAddresses = append(details.MACAddresses, iface.HardwareAddr)
	}

	return details, nil
}
