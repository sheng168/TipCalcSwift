//
//  ComplicationController.swift
//  TipCalc WatchKit Extension
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.None])
        log.debug("getSupportedTimeTravelDirectionsForComplication")
//        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        log.debug("getTimelineStartDateForComplication")
        let start = NSDate().dateByAddingTimeInterval(-100*60)
        handler(start)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        log.debug("getTimelineEndDateForComplication")
        let end = NSDate().dateByAddingTimeInterval(100*60)
        handler(end)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        log.debug("getPrivacyBehaviorForComplication")
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        log.debug("getCurrentTimelineEntryForComplication")
        
        
        let templ: CLKComplicationTemplate?
        
        switch complication.family {
//        case .ModularLarge:
//            let t = modularLarge(10.0)
//            templ = t
//        case .ModularSmall:
//            templ = modularSmall(10.0)
        default:
            templ = getTemplateForComplication(complication, bill: 10)
            break
        }
        
        if templ == nil {
             handler(nil)
        } else {
            let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: templ!)
            
            handler(entry)
        }

    }
    
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        log.debug("\(date) \(limit)")
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            var array = [CLKComplicationTimelineEntry]()
            
            for i in 1 ... limit {
                let t = self.getTemplateForComplication(complication, bill: Double(i))
                
                let entry = CLKComplicationTimelineEntry(date: NSDate(timeIntervalSinceNow: -60.0*Double(i)), complicationTemplate: t)
                array.append(entry)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                handler(array)
            }
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        log.debug("\(date) \(limit)")
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            var array = [CLKComplicationTimelineEntry]()
            
            for i in 1 ... limit {
                let t = self.getTemplateForComplication(complication, bill: Double(i))
                
                let entry = CLKComplicationTimelineEntry(date: NSDate(timeIntervalSinceNow: 60.0*Double(i)), complicationTemplate: t)
                array.append(entry)
            }
            
            handler(array)
        }
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        log.debug("")
//        handler(nil)
        handler(NSDate(timeIntervalSinceNow: 60*60))
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        log.debug("")
        
        let template: CLKComplicationTemplate? = getTemplateForComplication(complication, bill: 10)
        handler(template)
    }
    
    // MARK: - Generate Templates

    func getTemplateForComplication(complication: CLKComplication, bill: Double) -> CLKComplicationTemplate {
        // This method will be called once per supported complication, and the results will be cached
        log.debug("\(bill)")
        
        let template: CLKComplicationTemplate
        
        switch complication.family {
        case .ModularSmall:
            template = modularSmall(bill)
        case .ModularLarge:
            template = modularLarge(bill)
        case .UtilitarianSmall:
            template = utilitarianSmall(bill)
        case .UtilitarianLarge:
            template = utilitarianLarge(bill)
        case .CircularSmall:
            template = circularSmall(bill)
        }
        
        return (template)
    }

    private func modularSmall(bill: Double) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateModularSmallStackText()
        t.line1TextProvider = CLKSimpleTextProvider(text: "Tip \(bill)", shortText: "\(bill)")
        t.line2TextProvider = CLKSimpleTextProvider(text: "$\(bill*1.15)", shortText: "\(bill*1.15)")
        return t

    }
    
    private func modularLarge(bill: Double) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateModularLargeStandardBody()
        t.headerTextProvider = CLKSimpleTextProvider(text: "TipCalc $\(bill)")
        t.body1TextProvider = CLKSimpleTextProvider(text: "+ 15% = $\(bill*1.15)")
        t.body2TextProvider = CLKSimpleTextProvider(text: "\(NSDate())")
        return t
    }

    private func utilitarianSmall(bill: Double) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateUtilitarianSmallFlat()
        t.textProvider = CLKSimpleTextProvider(text: "Tip", shortText: "Tip")
//        t.imageProvider = CLKSimpleTextProvider(text: "$11.50", shortText: "11.50")
        return t
        
    }
    
    private func utilitarianLarge(bill: Double) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateUtilitarianLargeFlat()
        t.textProvider = CLKSimpleTextProvider(text: "TipCalc $\(bill)")
        
//        t.body1TextProvider = CLKSimpleTextProvider(text: "+ 15% = $\(bill*1.15)")
//        t.body2TextProvider = CLKSimpleTextProvider(text: "\(NSDate())")
        return t
    }

    private func circularSmall(bill: Double) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateCircularSmallStackText()
        t.line1TextProvider = CLKSimpleTextProvider(text: "$10", shortText: "10")
        t.line2TextProvider = CLKSimpleTextProvider(text: "11.50", shortText: "11.5")
        
        return t
    }

}
