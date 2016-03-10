import java.util.concurrent.atomic {
	
	AtomicReference
}


"Represents results of statistic computation of a stream of values."
shared class StatisticsSummary (
	"Minimum of the values that have been statisticaly treated."
	shared Float min = infinity,
	"Maximum of the values that have been statisticaly treated."
	shared Float max = -infinity,
	"Sum of the values that have been statisticaly treated."
	shared Float sum = 0.0,
	"Sum of the squares of the values that have been statisticaly treated."
	shared Float sumOfSquares = 0.0,
	"The number of the values that have been statisticaly treated."
	shared Integer size	= 0
)
		extends Object()
		satisfies Summable<StatisticsSummary>
{
	
	"Returns the mean of the values that have been statisticaly treated."
	shared Float mean => sum/size;
	
	"Returns variance of the values that have been statisticaly treated.
	 The variance is mean((x-mean(x))^2)."
	see(`value deviation`)
	shared Float variance => (sumOfSquares-sum*sum/size)/size;
	
	"Returns standard deviation of the values that have been statisticaly treated.
	 Standard deviation is `variance^0.5`."
	see(`value variance`)
	shared Float deviation => sqrt(variance);
	
	
	shared actual StatisticsSummary plus(StatisticsSummary other) 
		=> StatisticsSummary (
			if(min<other.min) then min else other.min,
			if(max>other.max) then max else other.max,
			sum+other.sum,
			sumOfSquares+other.sumOfSquares,
			size+other.size
		);
	
	shared actual Boolean equals(Object that) {
		if (is StatisticsSummary that) {
			return min==that.min && 
				max==that.max && 
				sum==that.sum && 
				sumOfSquares==that.sumOfSquares && 
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
		hash = 31*hash + sum.hash;
		hash = 31*hash + sumOfSquares.hash;
		hash = 31*hash + size.hash;
		return hash;
	}
	
	shared actual String string
			=>	"Summary statistics of size ``size``, max=``max``, min=``min``, mean=``mean``, deviation=``deviation``.";
	
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
 * Computes [[min]], [[max]], [[sum]], [[mean]], [[deviation]] and [[variance]].  
 * The data values are not stored in memory.
 * Thread safe data adding is supported.
 "
shared class StatisticsStream() {
	
	StatisticAtomicRef summaryRef = StatisticAtomicRef(StatisticsSummary());
	
	StatisticsSummary calculateFor(Float* values) {
		variable Float min = infinity;
		variable Float max = -infinity;
		variable Float sum = 0.0;
		variable Float sumOfSquares = 0.0;
		for (item in values) {
			if (item<min) {min = item;}
			if (max<item) {max = item;}
			sum += item;
			sumOfSquares += item*item;
		}
		return StatisticsSummary(min, max, sum, sumOfSquares, values.size);
	}
	
	
	"Adds values to the statistics data. The data values are not stored in memory.
	 Allows thread safe data adding."
	shared void addValues(Float* values) {
		StatisticsSummary added = calculateFor(*values);
		while (true) {
			StatisticsSummary current = summaryRef.get();
			if (summaryRef.compareAndSet(current, current + added)) {
				break;
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
	
	"Returns the sum of the values that have been added."
	see(`function addValues`)
	shared Float sum => summary.sum;
	
	"Returns the sum of the squares of the values that have been added."
	see(`function addValues`)
	shared Float sumOfSquares => summary.sumOfSquares;
	
	"Returns the number of the values that have been added."
	see(`function addValues`)
	shared Integer size => summary.size;
	
	"Returns the mean of the values that have been added."
	see(`function addValues`)
	shared Float mean => summary.mean;
	
	"Returns variance of the values that have been added.
	 The variance is mean((x-mean(x))^2)."
	see(`function addValues`)
	see(`value deviation`)
	shared Float variance => summary.variance;
	
	"Returns standard deviation of the values that have been added.
	 Standard deviation is `variance^0.5`."
	see(`function addValues`)
	see(`value variance`)
	shared Float deviation => summary.deviation;
	
	
	shared actual String string => summary.string;
	
}
