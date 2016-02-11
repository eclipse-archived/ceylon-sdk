shared
Float|Absent average<Absent>(
        Iterable<Float|Integer, Absent> xs)
        given Absent satisfies Null {

    // Kahan algorithm is 40% slower on Javascript
    // and likely not worth the improved accuracy.

    variable value sum = 0.0;
    variable value count = 0;

    value floats = xs.map(nearestFloat);

    for (x in floats) {
        count++;
        sum += x;
    }

    if (count > 0) {
        return sum / count;
    }
    else {
        assert (is Absent null);
        return null;
    }
}

"Return the mean and standard deviation of [[xs]], or [[null]]
 if `xs` has fewer than two elements."
shared
[Float, Float, Integer]? meanAndStdDev({<Float|Integer>*} xs) {
    variable value k = 0;
    variable value m = 0.0;
    variable value s = 0.0;

    value floats = xs.map(nearestFloat);

    // Welford’s method
    for (x in floats) {
        value prev = m;
        m += (x - m) / ++k;        // m = x first iter
        s += (x - m) * (x - prev); // s = 0 first iter
    }

    return (k > 1)
    then [m, (s / (k - 1)) ^ 0.5, k];
}

shared
Float chiSquared(
        "The maximum possible sample value, inclusive. The minimum must be 0."
        Integer max,
        "Number of buckets. `max + 1` must be evenly divisible by `buckets` to ensure an
         even distribution of samples."
        Integer buckets,
        "`samples.count` should be greater than or equal to `5 * buckets`."
        {<Integer>*} samples) {

    "max + 1 must be evenly divisible by the number of buckets."
    assert ((max + 1) % buckets == 0);

    value counts = Array.ofSize(buckets, 0);
    // (max + 1) may be negative if max == maxInteger
    value bucketSize = ((max + 1) / buckets).magnitude;
    variable value sampleCount = 0;
    for (sample in samples) {
        value bucketIndex = sample / bucketSize;
        counts.set(bucketIndex, (counts[bucketIndex] else 0) + 1);
        sampleCount++;
    }
    value expected = sampleCount.float / buckets;
    return sum({0.0, *counts.map((count)
        =>  (count.float - expected) ^ 2)}) / expected;
}

shared
Float chiSquaredDeviations(
        Integer max,
        Integer buckets,
        {<Integer>*} samples)
    // approximately correct for large # of buckets
    =>  let (mean = buckets - 1,
             variance = mean * 2,
             stdDev = variance.float ^ 0.5)
        (mean - chiSquared(max, buckets, samples)) / stdDev;

Boolean realInts = runtime.integerAddressableSize == 64;

shared
Float nearestFloat(Integer | Float x)
    =>  switch (x)
        case (is Float) x
        case (is Integer) x.nearestFloat;

shared
[Float, Float]? meanAndVarianceStdDevs(max, uniformSamples) {
    "upper bound, inclusive"
    Float max;

    "generate a sample with uniform distribution"
    {Float*} uniformSamples;

    function validateSample(Float sample) {
        assert (0.0 <= sample <= max);
        return sample;
    }

    if (exists [averageMeasured, stdDevMeasured, count] =
            meanAndStdDev(uniformSamples.map(validateSample))) {

        "expected variance for uniform distribution = `1/12 * (b-a)^2`"
        value uniformVariance = max ^ 2 / 12;
        value uniformStdDev = uniformVariance ^ 0.5;

        "expected standard devation of the average
         of count samples = `sampleStdDev / sqrt(count)`"
        value stdDevOfSampleAverage = uniformStdDev / count ^ 0.5;

        "variance of the sample variance for a uniform distribution.
         See <http://en.wikipedia.org/wiki/Variance#Distribution_of_the_sample_variance>"
        value varianceOfSampleVariance =
                let (n = count.float)
                let (k = -1.2)
                uniformStdDev ^ 4 * (2 / (n - 1) + k / n );
        value stdDevOfSampleVariance = varianceOfSampleVariance ^ 0.5;

        // measured
        value averageStdDevsMeasured =
                (max / 2 - averageMeasured) / stdDevOfSampleAverage;

        value varianceStdDevsMeasured =
                (uniformVariance - stdDevMeasured ^ 2) / stdDevOfSampleVariance;

        return [averageStdDevsMeasured, varianceStdDevsMeasured];
    }
    else {
        return null;
    }
}
