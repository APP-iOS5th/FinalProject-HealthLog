//
//  FunctionInfoPrint.swift
//  HealthLog
//
//  Created by user on 8/27/24.
//

import Foundation

func logFunctionInfo<T: AnyObject>(
    _ instance: T,
    functionName: String = #function,
    fileName: String = #file,
    lineNumber: Int = #line,
    columnNumber: Int = #column
) {
    let classNameOnly = NSStringFromClass(type(of: instance))
        .components(separatedBy: ".").last ?? "N/a"
    let fileNameOnly = fileName
        .components(separatedBy: "/").last ?? "N/a"
    print("-- \(fileNameOnly) | \(lineNumber)Line | \(classNameOnly).\(functionName) --")
}
