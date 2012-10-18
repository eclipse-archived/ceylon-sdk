shared class HttpdOptions() {
	shared variable Integer workerWriteThreads := 2;
	shared variable Integer workerReadThreads := 2;
	shared variable Integer workerTaskCoreThreads := 2;
	shared variable Integer workerTaskMaxThreads := 12;
	shared variable Integer connectionLowWatter := 1000000;
	shared variable Integer connectionHighWatter := 1000000;
	
} 