//
//  ViewController.m
//  Shop
//
//  Created by Kirill Ushkov on 3/11/17.
//  Copyright © 2017 Kirill Ushkov. All rights reserved.
//

#import "ViewController.h"
#import "Item.h"

// Далее необходимо определить источник данных для нашей таблицы, это можно посмотреть в UITableView.h

// Добавим реализацию протокола UITableViewDatasource в наш класс

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *toggleEditButton;
// добавим аутлет нашей таблицы
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// объявляем свойство класса для хранения информации о наших товарах
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) NSArray *shop;

// далее добавим изменяемый массив, который будет хранить товары
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // здесь будет выполняться основная логика
    
    // вначале читаем данные в массив
    [self readData];
    
    // затем отображаем эти данные
    [self showData];
    
    // но сначала надо установить наш класс как источник данных таблицы
    self.tableView.dataSource = self;
    
    // также необходимо установить свойство delegate таблицы наш класс
    self.tableView.delegate = self;
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
    
    // проиницианизируем массив товаров
    
    self.items = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in self.shop) {
        Item *itemObj = [[Item alloc] initWithDictionary:item];

        // теперь все объекты Item будем добавлять в массив items
        [self.items addObject:itemObj];
        
        if ([itemObj hasDiscount]) {
            [textRepresentation addObject:[itemObj itemDescription]];
        }
    }
    
    // далее формируем результирующую строку
    NSString *resultString = [textRepresentation componentsJoinedByString:@"\n"];
    
    // выведем получившийся результат визуально
    self.resultLabel.text = resultString;
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // здесь необходимо указать количество элементов в секции таблицы
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // здесь описываем визуальное представление данных в ячейках таблицы
    // введем переменную-идентификатор типа ячейки
    NSString *cellIdentifier = @"cellIdentifier"; // имя типа произвольное
    // здесь мы пробуем взять ячейку из очереди переиспользуемых дабы не создавать ее
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // если ячеек в очереди нет, создаем ее
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // далее добавим визуальное отображение данных
    
    // получим товар
    Item *item = [self.items objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:item.imageName];
    
    if (item.hasDiscount) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor grayColor];
    }
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [item itemDescription];
    
    // уберем подсветку выделенной ячейки
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

// далее добавим реагирование на нажатие ячейки - этим занимается протокол UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // получаем выбранную ячейку
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Товары";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item = [self.items objectAtIndex:indexPath.row];
    if (item.hasDiscount) {
        return UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.row];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        Item *item = [Item defaultItem];
        [self.items insertObject:item atIndex:indexPath.row];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    }
    
    [tableView reloadData];
}

#pragma mark - UI actions -

- (IBAction)toggleButtonTapped:(UIButton *)sender {
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
        self.toggleEditButton.titleLabel.text = @"";
        [self.toggleEditButton setTitle:@"Edit" forState:UIControlStateNormal];
        
    } else {
        [self.tableView setEditing:YES animated:YES];
        [self.toggleEditButton setTitle:@"Stop editing" forState:UIControlStateNormal];
    }
    
    
}


@end
