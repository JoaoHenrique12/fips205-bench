package main

import (
	"fmt"
	"os"
	pprof "runtime/pprof"
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

	for i := 0; i < nMessages; i++ {
		signature := signMessageEntrypoint(message)
		verifyMessageEntrypoint(message, signature)
		_ = signature
	}

	// Capture memory profile
	f, err := os.Create("bench-mem-{input_name}-{n_messages}.prof")
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
