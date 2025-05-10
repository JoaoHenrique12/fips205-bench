package main

import (
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"runtime/pprof"
	"strconv"
)

func signMessageEntrypoint(message string) string {
	signature := ""
	// use the imported library here
	return signature
}

func verifyMessageEntrypoint(message string, signature string) bool {
	isValid := true
	// use the imported library here
	return isValid
}

func main() {
	messagePath, nMessages, profilingType := readEnvVars()
	profilingFileName := getProfilingOutputName(messagePath, nMessages, profilingType)

	messageBytes, err := os.ReadFile(messagePath)
	if err != nil {
		fmt.Printf("Error reading message file: %v\n", err)
		os.Exit(1)
	}
	message := string(messageBytes)

	if profilingType == "cpu" {
		cpuFile, err := os.Create(profilingFileName)
		if err != nil {
			fmt.Fprintf(os.Stderr, "could not create CPU profile: %v\n", err)
			os.Exit(1)
		}
		defer cpuFile.Close()

		if err := pprof.StartCPUProfile(cpuFile); err != nil {
			fmt.Fprintf(os.Stderr, "could not start CPU profile: %v\n", err)
			os.Exit(1)
		}
		defer pprof.StopCPUProfile()
	}

	for i := 0; i < nMessages; i++ {
		signature := signMessageEntrypoint(message)
		verifyMessageEntrypoint(message, signature)
	}

	if profilingType == "mem" {
		memFile, err := os.Create(profilingFileName)
		if err != nil {
			fmt.Println("could not create memory profile: ", err)
			os.Exit(1)
		}
		defer memFile.Close()

		runtime.GC()
		if err := pprof.WriteHeapProfile(memFile); err != nil {
			fmt.Println("could not write memory profile: ", err)
			os.Exit(1)
		}
	}
}

func readEnvVars() (string, int, string) {
	nMessagesStr := os.Getenv("N_MESSAGES")
	if nMessagesStr == "" {
		nMessagesStr = "1"
	}
	messagePath := os.Getenv("MESSAGE_PATH")

	if messagePath == "" {
		fmt.Println("MESSAGE_PATH env var not defined !")
		os.Exit(1)
	}

	nMessages, err := strconv.Atoi(nMessagesStr)
	if err != nil {
		fmt.Println("N_MESSAGES must be an integer if defined!")
		os.Exit(1)
	}

	profilingType := os.Getenv("PROFILING_TYPE")
	if profilingType != "mem" && profilingType != "cpu" {
		fmt.Println("PROFILING_TYPE env var validation error options available: ! [mem|cpu]")
		os.Exit(1)
	}

	return messagePath, nMessages, profilingType
}

func getProfilingOutputName(messagePath string, nMessages int, profilingType string) string {
	inputName := filepath.Base(messagePath)
	inputName = inputName[:len(inputName)-len(filepath.Ext(inputName))] // remove the sufix
	fileName := fmt.Sprintf("bench-%s-%s-%d.prof", profilingType, inputName, nMessages)

	return fileName
}
