//
//  SPCSVExporterProtocol.h
//  sequel-pro
//
//  Created by Stuart Connolly (stuconnolly.com) on April 15, 2010.
//  Copyright (c) 2010 Stuart Connolly. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  More info at <https://github.com/rstreefland/rsequelpro>

@class SPCSVExporter;

/**
 * @protocol SPCSVExporterProtocol SPCSVExporterProtocol.h
 *
 * @author Stuart Connolly http://stuconnolly.com/ 
 *
 * CSV exporter delegate protocol.
 */
@protocol SPCSVExporterProtocol

/**
 * Called when the CSV export process is about to begin. 
 *
 * @param SPCSVExporter The expoter calling the method.
 */
- (void)csvExportProcessWillBegin:(SPCSVExporter *)exporter;

/**
 * Called when the CSV export process is complete.
 *
 * @param SPCSVExporter The expoter calling the method.
 */
- (void)csvExportProcessComplete:(SPCSVExporter *)exporter;

/**
 * Called when the progress of the CSV export process is updated.
 *
 * @param SPCSVExporter The expoter calling the method.
 */
- (void)csvExportProcessProgressUpdated:(SPCSVExporter *)exporter;

/**
 * Called when the CSV export process is about to begin writing data to disk.
 *
 * @param SPCSVExporter The expoter calling the method.
 */
- (void)csvExportProcessWillBeginWritingData:(SPCSVExporter *)exporter;

@end
