#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

// Signal handler for SIGTERM
void sigterm_handler(int signum) {
    printf("\n[Parent] Received SIGTERM (signal %d)\n", signum);
    printf("[Parent] Handling SIGTERM - Performing cleanup...\n");
    printf("[Parent] Cleanup complete. Continuing...\n\n");
}

// Signal handler for SIGINT
void sigint_handler(int signum) {
    printf("\n[Parent] Received SIGINT (signal %d)\n", signum);
    printf("[Parent] Handling SIGINT - Gracefully shutting down...\n");
    printf("[Parent] Goodbye!\n");
    exit(0);
}

int main() {
    pid_t child1_pid, child2_pid;
    
    printf("Signal Handling Demonstration\n");
    printf("==============================\n");
    printf("Parent PID: %d\n\n", getpid());
    
    // Set up signal handlers
    signal(SIGTERM, sigterm_handler);
    signal(SIGINT, sigint_handler);
    
    printf("Signal handlers installed:\n");
    printf("  - SIGTERM: cleanup handler\n");
    printf("  - SIGINT: graceful shutdown\n\n");
    
    // Create first child - sends SIGTERM after 5 seconds
    child1_pid = fork();
    
    if (child1_pid < 0) {
        perror("Fork failed");
        exit(1);
    }
    else if (child1_pid == 0) {
        // Child 1 process
        printf("[Child 1] PID: %d - Will send SIGTERM to parent after 5 seconds\n", getpid());
        sleep(5);
        
        printf("[Child 1] Sending SIGTERM to parent (PID: %d)\n", getppid());
        kill(getppid(), SIGTERM);
        
        printf("[Child 1] Exiting...\n");
        exit(0);
    }
    
    // Create second child - sends SIGINT after 10 seconds
    child2_pid = fork();
    
    if (child2_pid < 0) {
        perror("Fork failed");
        exit(1);
    }
    else if (child2_pid == 0) {
        // Child 2 process
        printf("[Child 2] PID: %d - Will send SIGINT to parent after 10 seconds\n\n", getpid());
        sleep(10);
        
        printf("[Child 2] Sending SIGINT to parent (PID: %d)\n", getppid());
        kill(getppid(), SIGINT);
        
        printf("[Child 2] Exiting...\n");
        exit(0);
    }
    
    // Parent process - runs indefinitely until signal received
    printf("[Parent] Running indefinitely (waiting for signals)...\n");
    printf("[Parent] Press Ctrl+C or wait for children to send signals\n\n");
    
    int counter = 0;
    while (1) {
        printf("[Parent] Still running... (iteration %d)\n", ++counter);
        sleep(2);
        
        // Check if children have terminated
        int status;
        pid_t result = waitpid(-1, &status, WNOHANG);
        if (result > 0) {
            printf("[Parent] Cleaned up child process: %d\n", result);
        }
    }
    
    return 0;
}
