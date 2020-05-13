```java
<T> List<List<T>> partition(List<T> list, int partitions)
{
    assert partitions > 0;
    assert list != null;
    partitions = Math.min(partitions, list.size());
    List<List<T>> result = new ArrayList<>(partitions);
    for (int i = 0; i < partitions; i++) result.add(new ArrayList<>());
    int n = 0;
    for (T t : list)
    {
        n = n % result.size();
        result.get(n).add(t);
        n++;
    }
    return result;
}
```
