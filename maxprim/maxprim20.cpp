#include <iostream>
#include <cmath>
using namespace std;

// Function to check if a number is prime
bool isPrime(int num) {
    if (num <= 1) return false;
    for (int i = 2; i <= sqrt(num); ++i) {
        if (num % i == 0) return false;
    }
    return true;
}

// Function to find the largest prime factor of a number
int largestPrimeFactor(int num) {
    int largest = -1;

    // Check for smallest prime factor (2)
    while (num % 2 == 0) {
        largest = 2;
        num /= 2;
    }

    // Check for odd prime factors
    for (int i = 3; i <= sqrt(num); i += 2) {
        while (num % i == 0) {
            largest = i;
            num /= i;
        }
    }

    // If remaining number is a prime greater than 2
    if (num > 2) {
        largest = num;
    }

    return largest;
}

int main() {
    int n;
    cin >> n;
    while (n--) {
        int num;
        cin >> num;
        cout << largestPrimeFactor(num) << endl;
    }
    return 0;
}
