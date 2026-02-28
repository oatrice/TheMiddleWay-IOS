
import Foundation

// Helper to create localized titles (placeholder for now)
func LocalizedTitle(_ en: String, _ th: String) -> String {
    // Basic i18n logic: default to English for MVP, consistent with Android
    return en
}

struct WisdomGardenData {
    static var weeklyData: [WeeklyData] = [
                    WeeklyData(weekNumber: 1, categories: [
            PracticeCategory(id: "cat_giving", title: "Giving (Dana)", items: [
                PracticeItem(id: "w1_i1", title: "Shared food or resources", points: 10, isCompleted: false),
                PracticeItem(id: "w1_i2", title: "Offered help to someone", points: 10, isCompleted: false),
                PracticeItem(id: "w1_i3", title: "Spoke kind words", points: 10, isCompleted: false),
                PracticeItem(id: "w1_i4", title: "Practiced forgiveness", points: 10, isCompleted: false)
            ])
        ]),
        // Week 2: Morality (Sila)
        WeeklyData(weekNumber: 2, categories: [
            PracticeCategory(id: "cat_sila", title: "Morality (Sila)", items: [
                PracticeItem(id: "w2_i1", title: "Refrained from harming living beings", points: 10, isCompleted: false),
                PracticeItem(id: "w2_i2", title: "Refrained from taking what is not given", points: 10, isCompleted: false),
                PracticeItem(id: "w2_i3", title: "Refrained from sexual misconduct", points: 10, isCompleted: false),
                PracticeItem(id: "w2_i4", title: "Refrained from false speech", points: 10, isCompleted: false)
            ])
        ]),
        // Week 3: Renunciation (Nekkhamma)
        WeeklyData(weekNumber: 3, categories: [
            PracticeCategory(id: "cat_nekk", title: "Renunciation", items: [
                PracticeItem(id: "w3_i1", title: "Moderated sensory pleasures", points: 10, isCompleted: false),
                PracticeItem(id: "w3_i2", title: "Practiced contentment with what I have", points: 10, isCompleted: false),
                PracticeItem(id: "w3_i3", title: "Reduced unnecessary consumption", points: 10, isCompleted: false),
                PracticeItem(id: "w3_i4", title: "Spent time in quiet reflection", points: 10, isCompleted: false)
            ])
        ]),
        // Week 4: Wisdom (Panna)
        WeeklyData(weekNumber: 4, categories: [
            PracticeCategory(id: "cat_panna", title: "Wisdom", items: [
                PracticeItem(id: "w4_i1", title: "Studied Dhamma or listened to a talk", points: 10, isCompleted: false),
                PracticeItem(id: "w4_i2", title: "Reflected on impermanence (Anicca)", points: 10, isCompleted: false),
                PracticeItem(id: "w4_i3", title: "Observed cause and effect in daily life", points: 10, isCompleted: false),
                PracticeItem(id: "w4_i4", title: "Discussed Dhamma with others", points: 10, isCompleted: false)
            ])
        ]),
        // Week 5: Energy (Viriya)
        WeeklyData(weekNumber: 5, categories: [
            PracticeCategory(id: "cat_viriya", title: "Energy", items: [
                PracticeItem(id: "w5_i1", title: "Aroused energy to prevent unwholesome states", points: 10, isCompleted: false),
                PracticeItem(id: "w5_i2", title: "Aroused energy to abandon unwholesome states", points: 10, isCompleted: false),
                PracticeItem(id: "w5_i3", title: "Developed wholesome states", points: 10, isCompleted: false),
                PracticeItem(id: "w5_i4", title: "Maintained wholesome states", points: 10, isCompleted: false)
            ])
        ]),
        // Week 6: Patience (Khanti)
        WeeklyData(weekNumber: 6, categories: [
            PracticeCategory(id: "cat_khanti", title: "Patience", items: [
                PracticeItem(id: "w6_i1", title: "Endured physical discomfort without complaint", points: 10, isCompleted: false),
                PracticeItem(id: "w6_i2", title: "Endured harsh words from others", points: 10, isCompleted: false),
                PracticeItem(id: "w6_i3", title: "Waited calmly when delayed", points: 10, isCompleted: false),
                PracticeItem(id: "w6_i4", title: "Forgave myself for shortcomings", points: 10, isCompleted: false)
            ])
        ]),
        // Week 7: Truthfulness (Sacca)
        WeeklyData(weekNumber: 7, categories: [
            PracticeCategory(id: "cat_sacca", title: "Truthfulness", items: [
                PracticeItem(id: "w7_i1", title: "Spoke only what is true and beneficial", points: 10, isCompleted: false),
                PracticeItem(id: "w7_i2", title: "Kept promises made to myself and others", points: 10, isCompleted: false),
                PracticeItem(id: "w7_i3", title: "Was honest about my feelings and intentions", points: 10, isCompleted: false),
                PracticeItem(id: "w7_i4", title: "Admitted mistakes openly", points: 10, isCompleted: false)
            ])
        ]),
        // Week 8: Determination (Adhitthana)
        WeeklyData(weekNumber: 8, categories: [
            PracticeCategory(id: "cat_adhit", title: "Determination", items: [
                PracticeItem(id: "w8_i1", title: "Set a clear intention for the day", points: 10, isCompleted: false),
                PracticeItem(id: "w8_i2", title: "Persisted in a difficult task", points: 10, isCompleted: false),
                PracticeItem(id: "w8_i3", title: "Reniewed commitment to the path", points: 10, isCompleted: false),
                PracticeItem(id: "w8_i4", title: "Overcame an obstacle with resolve", points: 10, isCompleted: false)
            ])
        ])
    ]
}
