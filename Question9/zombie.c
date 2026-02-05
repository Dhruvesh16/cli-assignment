#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>

#define NUM_CHILDREN 5

int main() {
    pid_t pid;
    int i;
    
    printf("Zombie Process Prevention Demo\n");
    printf("================================\n");
    printf("Parent PID: %d\n\n", getpid());
    
    // Create multiple child processes
    for (i = 0; i < NUM_CHILDREN; i++) {
        pid = fork();
        
        if (pid < 0) {
            // Fork failed
            perror("Fork failed");
            exit(1);
        }
        else if (pid == 0) {
            // Child process
            printf("Child %d created with PID: %d\n", i+1, getpid());
            
            // Child does some work and exits
            sleep(1);
            printf("Child %d (PID: %d) exiting...\n", i+1, getpid());
            exit(0);
        }
        // Parent continues to create more children
    }
    
    // Parent process waits for all children
    printf("\nParent waiting for all children to terminate...\n\n");
    
    int status;
    pid_t terminated_pid;
    
    // Wait for each child and clean up
    for (i = 0; i < NUM_CHILDREN; i++) {
        terminated_pid = wait(&status);
        
        if (terminated_pid > 0) {
            printf("Parent cleaned up child with PID: %d\n", terminated_pid);
            
            if (WIFEXITED(status)) {
                printf("  - Exit status: %d\n", WEXITSTATUS(status));
            }
        }
    }
    
    printf("\nAll children cleaned up successfully!\n");
    printf("No zombie processes remain.\n");
    printf("================================\n");
    
    return 0;
}
