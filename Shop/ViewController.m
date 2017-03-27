//
//  ViewController.m
//  Shop
//
//  Created by Kirill Ushkov on 3/11/17.
//  Copyright © 2017 Kirill Ushkov. All rights reserved.
//

#import "ViewController.h"
#import "Item.h"

@interface ViewController ()
// объявляем свойство класса для хранения информации о наших товарах
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) NSArray *shop;
@end

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
        Item *itemObj = [[Item alloc] initWithDictionary:item];

        if (itemObj) {
            [textRepresentation addObject:[itemObj itemDescription]];
        }
    }
    
    // далее формируем результирующую строку
    NSString *resultString = [textRepresentation componentsJoinedByString:@"\n"];
    
    // выведем получившийся результат визуально
    self.resultLabel.text = resultString;
}

@end
