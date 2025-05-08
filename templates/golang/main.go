package main

import (
	"fmt"
	"os"
	"path/filepath"
	"runtime/pprof"
	"runtime"
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
	// Reading env vars
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

	messageBytes, err := os.ReadFile(messagePath)
	if err != nil {
		fmt.Printf("Error reading message file: %v\n", err)
		os.Exit(1)
	}
	message := string(messageBytes)

	profilingType := os.Getenv("PROFILING_TYPE")
	if profilingType != "mem" && profilingType != "cpu" {
		fmt.Println("PROFILING_TYPE env var validation error options available: ! [mem|cpu]")
		os.Exit(1)
	}

	// mounting output name
	inputName := filepath.Base(messagePath)
	inputName = inputName[:len(inputName)-len(filepath.Ext(inputName))] // remove the sufix
	fileName := fmt.Sprintf("bench-%s-%s-%d.prof", profilingType, inputName, nMessages)

  if profilingType == "cpu" {
  	// Create CPU profile file
  	cpuFile, err := os.Create(fileName)
  	if err != nil {
	  	fmt.Fprintf(os.Stderr, "could not create CPU profile: %v\n", err)
	  	os.Exit(1)
  	}
  	defer cpuFile.Close()

  	// Start CPU profiling
  	if err := pprof.StartCPUProfile(cpuFile); err != nil {
	  	fmt.Fprintf(os.Stderr, "could not start CPU profile: %v\n", err)
	  	os.Exit(1)
  	}
  	defer pprof.StopCPUProfile()
  }


	for i := 0; i < nMessages; i++ {
		signature := signMessageEntrypoint(message)
		verifyMessageEntrypoint(message, signature)
		_ = signature
	}

	if profilingType == "mem" {

		f, err := os.Create(fileName)
		if err != nil {
			fmt.Println("could not create memory profile: ", err)
			os.Exit(1)
		}
		defer f.Close()

		runtime.GC()
		if err := pprof.WriteHeapProfile(f); err != nil {
			fmt.Println("could not write memory profile: ", err)
			os.Exit(1)
		}
	}
}
