/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""
   Ceylon Random provides:

    - a pseudorandom number generator ([[DefaultRandom]]),
    - toplevel utility functions to shuffle streams or arrays ([[randomize]]
      and [[randomizeInPlace]]), and
    - an easy to implement interface for use by third party random number generators
      ([[Random]]).

   To generate random numbers, create and use an instance of [[DefaultRandom]]:

       // Create a random number generator
       value random = DefaultRandom();

       // Print a pseudorandom Float in the range 0.0 to 1.0:
       print (random.nextFloat());

   Other simple methods include [[Random.nextBits()]], [[Random.nextBoolean()]],
   [[Random.nextByte()]], and [[Random.nextInteger()]].

   [[Random.nextElement()]] can be used to generate a random number within a [[Range]]:

       print(random.nextElement(1..100));
       // Sample output: 27

   or select a random element from a [[Sequence]]:

       print(random.nextElement(["heads", "tails"]));
       // Sample output: heads

   It is also possible to obtain an infinite stream of random values using the methods
   [[Random.bits()]], [[Random.booleans()]], [[Random.bytes()]], [[Random.elements()]],
   [[Random.floats]], and [[Random.integers()]].

   For example, to simulate multiple rolls of a die:

       value diceStream => random.elements([*('⚀':6)]);
       print(diceStream.take(10));
       // Sample output: { ⚂, ⚀, ⚀, ⚂, ⚀, ⚅, ⚁, ⚅, ⚅, ⚁ }

   Finally, [[randomize()]] and [[randomizeInPlace()]] can be used to shuffle a list:

       print(randomize {
           for (suit in {"♠", "♥", "♦", "♣"})
           for (rank in {"Ace", "King", "Queen", "Jack",
                         *(10..2)*.string})
           suit + rank
       }.take(5));
       // sample output: { ♥6, ♣Queen, ♦King, ♥King, ♣10 }
"""
by("John Vasileff")
license("Apache Software License")
label("Ceylon Random Number Generation API")
module ceylon.random maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {}
