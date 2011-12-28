//
//  bart4Filter.h
//  bart4
//
//  Copyright (c) 2011 Bartek. All rights reserved.
//
#include "definicje.h"
#import <Foundation/Foundation.h>
#import "OsiriXAPI/PluginFilter.h"
/** Klasa dziedziczy po Plugin Filter, typowo */
@interface bart4Filter : PluginFilter {
}
/** Funkcja wywolywana podczas uruchamiania wtyczki. Cos w stylu f. main dla wtyczki.
 * \param menuName okresla w ktorym miejscu w menu wtyczek jest wywolanie tej wtyczki (wtyczki mozna uruchamiac z wielu roznych lokalizacji)
 * \return \TODO ???
 */
- (long) filterImage:(NSString*) menuName;
/** Funkcja wywolywana przez OsiriXa podczas uruchamiania programu (NIE podczas uruchamiania wtyczki!)
 */
- (void) initPlugin;

- (void) executeFilter:(int)lowerValue: (int)upperValue: (int)xPosition: (int)yPosition: (int)zPosition;
- (void) resetImage; 


@end
