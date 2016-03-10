import java.util.concurrent.atomic {
	
	AtomicReference
}

"Represents results of statistic computation of a stream of values."
class StatisticsSummary (
	"Minimum of the values that have been statisticaly treated."
	shared Float min = infinity,
	"Maximum of the values that have been statisticaly treated."
	shared Float max = -infinity,
	"Mean calculated within Welford's method of standard deviation computation."
	shared Float mean = 0.0,
	"Second moment used in Welford's method of standard deviation computation."
	shared Float m2 = 0.0,
	"The number of the values that have been statisticaly treated."
	shared Integer size	= 0
)
		extends Object()
{
	
	"Returns variance of the values that have been statisticaly treated.
	 The variance is mean((x-mean(x))^2)."
	see(`value standardDeviation`)
	shared Float variance => m2/(size-1);
	
	"Returns standard deviation of the values that have been statisticaly treated.
	 Standard deviation is `variance^0.5`."
	see(`value variance`)
	shared Float standardDeviation => sqrt(variance);
	
	
	shared actual Boolean equals(Object that) {
		if (is StatisticsSummary that) {
			return min==that.min && 
				max==that.max && 
				mean==that.mean && 
				m2==that.m2 &&
				size==that.size;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + min.hash;
		hash = 31*hash + max.hash;
		hash = 31*hash + mean.hash;
		hash = 31*hash + m2.hash;
		hash = 31*hash + size.hash;
		return hash;
	}
	
	shared actual String string
			=>	"Summary statistics of size ``size``, max=``max``, min=``min``, mean=``mean``, deviation=``standardDeviation``.";
	
}


native class StatisticAtomicRef(StatisticsSummary initial) {
	shared native StatisticsSummary get();
	shared native Boolean compareAndSet(StatisticsSummary toCompare, StatisticsSummary toSet);
}

native("js") class StatisticAtomicRef(StatisticsSummary initial) {
	variable StatisticsSummary store = initial;
	shared native("js") StatisticsSummary get() => store;
	shared native("js") Boolean compareAndSet(StatisticsSummary toCompare, StatisticsSummary toSet) {
		if (store==toCompare) {
			store = toSet;
			return true;
		}
		else {
			return false;
		}
	}
}

native("jvm") class StatisticAtomicRef(StatisticsSummary initial) {
	AtomicReference<StatisticsSummary> store = AtomicReference(initial);
	shared native("jvm") StatisticsSummary get() => store.get();
	shared native("jvm") Boolean compareAndSet(StatisticsSummary toCompare, StatisticsSummary toSet)
			=> store.compareAndSet(toCompare, toSet);
}


"Computes summary statistics for a stream of data values added using the [[addValues]] method.
 
 Features:
 * Computes [[min]], [[max]], [[sum]], [[mean]], [[standardDeviation]] and [[variance]].  
 * The data values are not stored in memory.
 * Thread safe data adding is supported.
 "
shared class StatisticsStream() {
	
	StatisticAtomicRef summaryRef = StatisticAtomicRef(StatisticsSummary());
	
	StatisticsSummary combineWith(StatisticsSummary summary, Float* values) {
		variable Float min = summary.min;
		variable Float max = summary.max;
		variable Float mean = summary.mean;
		variable Float m2 = if (summary.size<2) then 0.0 else summary.m2;
		variable Integer n = summary.size;
		for (item in values) {
			n ++;
			if (item<min) {min = item;}
			if (max<item) {max = item;}
			// Welford's method for mean and variance
			Float delta = item - mean;
			mean += delta / n;
			m2 += delta*(item - mean);
		}
		return StatisticsSummary(min, max, mean, m2, n);
	}
	
		
	"Adds values to the statistics data. The data values are not stored in memory.
	 Allows thread safe data adding."
	shared void addValues(Float* values) {
		if ( !values.empty ) {
			while (true) {
				StatisticsSummary current = summaryRef.get();
				if (summaryRef.compareAndSet(current, combineWith( current, *values))) {
					break;
				}
			}
		}
	}
	
	"Resets the statistics stream to initial state (no values added)."
	shared void clear() {
		StatisticsSummary empty = StatisticsSummary();
		while (true) {
			StatisticsSummary current = summaryRef.get();
			if (summaryRef.compareAndSet(current, empty)) {
				break;
			}
		}
	}
	
	
	"Statistics summary of the added data."
	StatisticsSummary summary => summaryRef.get();
	
	"Returns the minimum of the values that have been added."
	see(`function addValues`)
	shared Float min => summary.min;
	
	"Returns the maximum of the values that have been added."
	see(`function addValues`)
	shared Float max => summary.max;
	
	"Returns the number of the values that have been added."
	see(`function addValues`)
	shared Integer size => summary.size;
	
	"Returns the mean of the values that have been added."
	see(`function addValues`)
	shared Float mean => summary.mean;
	
	"Returns variance of the values that have been added.
	 The variance is mean((x-mean(x))^2)."
	see(`function addValues`)
	see(`value standardDeviation`)
	shared Float variance => summary.variance;
	
	"Returns standard deviation of the values that have been added.
	 Standard deviation is `variance^0.5`."
	see(`function addValues`)
	see(`value variance`)
	shared Float standardDeviation => summary.standardDeviation;
	
	
	shared actual String string => summary.string;
	
}
