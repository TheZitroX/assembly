

void sortArray(int* array)
{
    int median = 0;
    int array_length = 0;
    while (array[array_length] != 0)
        array_length++;

    for(int i = array_length - 1; i >= 0; i--)
        for (int j = 1; j <= i; j++)
            if (array[j - 1] > array[j])
            {
                const int temp = array[j - 1];
                array[j - 1] = array[j];
                array[j] = temp;
            }
            

    // 0011 == 3
    // 0010 == 2
    // 0100 == 4
    // 0101 == 5

    // when is grade
    if (array_length % 2 == 0)
        median = (array[array_length / 2] +
            array[array_length / 2 - 1]) / 2;
    else // wenn nicht gerade
        median = array[array_length / 2 + 1];
}