//
//  ViewController.m
//  Shop
//
//  Created by Kirill Ushkov on 3/11/17.
//  Copyright © 2017 Kirill Ushkov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
// объявляем свойство класса для хранения информации о наших товарах
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) NSArray *shop;
@end


#define PRICE(cost, percent) cost * percent/100.0f

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // здесь будет выполняться основная логика
    
    // вначале читаем данные в массив
    [self readData];
    
    // затем отображаем эти данные
    [self showData];
}


// объявим метод для чтения данных из plist файла

- (void)readData {
    // получим путь к этому файлу
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Items" withExtension:@"plist"];
    // далее мы можем создать массив используя данные из plist файла
    self.shop = [NSArray arrayWithContentsOfURL:fileURL];
}

// объявим метод для отображения данных

- (void)showData {
    // для начала проверим структуру данных в нашем массиве
    NSLog(@"Data array %@", self.shop);
    
    // далее напишем логику для получения текстовых представлений каждого товара
    NSMutableArray *textRepresentation = [NSMutableArray array];
    
    for (NSDictionary *item in self.shop) {
        
        NSString *title = [item objectForKey:@"title"];
        NSNumber *cost = [item objectForKey:@"cost"];
        NSNumber *availableNumber = [item objectForKey:@"availableNumber"];
        NSString *manufacturer = [item objectForKey:@"manufacturer"];
        
        BOOL hasDiscount = [[item objectForKey:@"manufacturer"] boolValue];
        
        if (hasDiscount) {
            CGFloat discount = PRICE(cost.floatValue, 50);
            NSNumber *res = [NSNumber numberWithFloat:discount];
            
            // вот таким образом у нас будет представлен товар
            NSString *result = [NSString stringWithFormat:@"Title - %@, cost - %@, available number - %@, manufacturer - %@, cost with discount - %@", title, cost, availableNumber, manufacturer, res];
            
            [textRepresentation addObject:result];

        }
        
    }
    
    // далее формируем результирующую строку
    NSString *resultString = [textRepresentation componentsJoinedByString:@"\n"];
    
    // выведем получившийся результат визуально
    
    self.resultLabel.text = resultString;
}

@end
