//
//  $Id: SPTextAndLinkCell.h 866 2009-06-15 16:05:54Z bibiko $
//
//  SPTextAndLinkCell.h
//  sequel-pro
//
//  Created by Rowan Beentje on 16/07/2009.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
//  More info at <http://code.google.com/p/sequel-pro/>

#import <Cocoa/Cocoa.h>

enum sptextandlinkcell_drawstates
{
	SP_LINKDRAWSTATE_NORMAL = 0,
	SP_LINKDRAWSTATE_HIGHLIGHT = 1,
	SP_LINKDRAWSTATE_BACKGROUNDHIGHLIGHT = 2
};

@interface SPTextAndLinkCell : NSTextFieldCell {
	BOOL hasLink;

	NSButtonCell *linkButton;
	id linkTarget;
	SEL linkAction;
	
	int lastLinkColumn;
	int lastLinkRow;
	int drawState;
}

- (void) setTarget:(id)theTarget action:(SEL)theAction;
- (int) getClickedColumn;
- (int) getClickedRow;

@end
