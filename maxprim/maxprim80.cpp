#include <iostream>
#include <vector>
#include <cmath>
#include <algorithm>

bool isPrimeLimited(int num) {
    if (num <= 1) return false;
    for (int i = 2; i <= 100; ++i) { // Arbitrary limit of 100
        if (i == num) continue; // Skip itself if it's less than 100
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

    int largestPrime = 0;
    for (int num : arr) {
        if (isPrimeLimited(num)) {
            largestPrime = std::max(largestPrime, num);
        }
    }

    std::cout << largestPrime << std::endl;
    return 0;
}
