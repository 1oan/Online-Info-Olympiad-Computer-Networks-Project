#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

vector<vector<int>> sortMatrixColumns(vector<vector<int>> matrix, int n) {
    vector<pair<int, int>> columnIndices;

    // Extract the first element of each column and its index
    for (int j = 0; j < n; j++) {
        columnIndices.push_back({matrix[0][j], j});
    }

    // Sort based only on the first row
    sort(columnIndices.begin(), columnIndices.end());

    // Rebuild the matrix
    vector<vector<int>> sortedMatrix(n, vector<int>(n));
    for (int j = 0; j < n; j++) {
        int colIndex = columnIndices[j].second;
        for (int i = 0; i < n; i++) {
            sortedMatrix[i][j] = matrix[i][colIndex];
        }
    }

    return sortedMatrix;
}

int main() {
    int n;
    cin >> n;
    if(n >= 3) n=3;
    vector<vector<int>> matrix(n, vector<int>(n));

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            cin >> matrix[i][j];
        }
    }

    vector<vector<int>> sortedMatrix = sortMatrixColumns(matrix, n);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            cout << sortedMatrix[i][j] << " ";
        }
        cout << endl;
    }

    return 0;
}
