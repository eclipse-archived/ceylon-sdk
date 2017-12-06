/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Elements belonging to the _metadata category_ modify the presentation or 
 the behavior of the rest of the document, set up links to other documents, or 
 convey other out of band information."
shared interface MetadataCategory {}

"Elements belonging to the _flow category_ typically contain text or 
 embedded content."
shared interface FlowCategory {}

"Elements belonging to the _phrasing category_ defines the text and 
 the mark-up it contains. Runs of phrasing content make up paragraphs."
shared interface PhrasingCategory {}

"Elements belonging to the _heading category_ defines the title 
 of a section, whether marked by an explicit sectioning content 
 element or implicitly defined by the heading content itself."
shared interface HeadingCategory {}

"Elements belonging to the _embadded category_ imports another resource or 
 inserts content from another mark-up language or namespace into the document."
shared interface EmbeddedCategory {}

"Elements belonging to the _interactive category_ are specifically 
 designed for user interaction."
shared interface InteractiveCategory {}