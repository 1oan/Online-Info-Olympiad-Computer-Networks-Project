#include <iostream>
#include <vector>
#include <cmath>
#include <algorithm>

bool isPrime(int num) {
    if (num <= 1) return false;
    for (int i = 2; i <= std::sqrt(num); ++i) {
        if (num % i == 0) return false;
    }
    return true;
}

int main() {
    int n;
    std::cin >> n;
    std::vector<int> arr(n);

    for (int i = 0; i < n; ++i) {
        std::cin >> arr[i];
    }

    int largestPrime = -1;
    for (int num : arr) {
        if (isPrime(num)) {
            largestPrime = std::max(largestPrime, num);
        }
    }

    std::cout << largestPrime << std::endl;
    return 0;
}

