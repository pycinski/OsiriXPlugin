//
//  importFilterWrapper.h
//  bart4
//
//  Created by Bartlomiej Pycinski on 11-11-11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "OsiriXApi/ViewerController.h"
#include <itkObject.h>
#include <itkImage.h>
#include "bartImportFilter.h"
typedef float myPixelType;
//typedef itk::Image <itkPixelType, 3> ImageType;
//typedef itk::ImportImageFilter <itkPixelType, 3> ImportFilterType;
//typedef bartImportFilter <itkPixelType, 3> ImportFilterType;


@interface importFilterWrapper : NSObject {
@private
    ViewerController* viewerController;
    bartImportFilter<myPixelType,3>::Pointer importFilter;
    long totalSize;
}


-(importFilterWrapper*) initWithViewerController: (ViewerController*) vc;
//TODO: to moze powinna byc prywatna funkcja, wywolywana przez konstruktor?
-(void) getDataFromViewer;
-(itk::Image<float,3>*) GetOutput;
-(long) GetSize;
@end
