/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute that represents the shape of the associated hot spot."
tagged("enumerated attribute")
shared class Shape
        of circle | default | poly | rect 
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "In the circle state, area elements must have a coords attribute present, 
     with three integers, the last of which must be non-negative. The first 
     integer must be the distance in CSS pixels from the left edge of the 
     image to the center of the circle, the second integer must be the 
     distance in CSS pixels from the top edge of the image to the center 
     of the circle, and the third integer must be the radius of the circle, 
     again in CSS pixels."
    shared new circle {
        attributeValue = "circle";
    }
    
    "In the default state state, area elements must not have a coords 
     attribute. The area is the whole image."
    shared new default {
        attributeValue = "default";
    }
    
    "In the polygon state, area elements must have a coords attribute with at 
     least six integers, and the number of integers must be even. Each pair of 
     integers must represent a coordinate given as the distances from the left 
     and the top of the image in CSS pixels respectively, and all the coordinates 
     together must represent the points of the polygon, in order."
    shared new poly {
        attributeValue = "poly";
    }
    
    "In the rectangle state, area elements must have a coords attribute with 
     exactly four integers, the first of which must be less than the third, 
     and the second of which must be less than the fourth. The four points 
     must represent, respectively, the distance from the left edge of the 
     image to the left side of the rectangle, the distance from the top edge 
     to the top side, the distance from the left edge to the right side, and 
     the distance from the top edge to the bottom side, all in CSS pixels."
    shared new rect {
        attributeValue = "rect";
    }
    
}