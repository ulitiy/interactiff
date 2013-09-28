var I18n = I18n || {};
I18n.translations = {"ru":{"admin":{"title":"Конструктор","links":{"save":"Сохранить","destroy":"Удалить","sure":"Вы уверены?","reset":"Сбросить события перед тестированием?"},"path":{"root":"Мои сценарии","level_up":"&larr;&nbsp;&nbsp;Общий вид","reload":"<span class=\"carrow\">&#8635</span> Обновить"},"help":{"link":"Помощь","options":{"overview":"Обзор","basic":"Базовое использование","nl_quests":"Нелинейные сценарии","variables":"Переменные","hot_keys":"Горячие клавиши","documentation":"Документация","examples":"Примеры","examples_menu":{"variables":"Переменные","nl_quests":"Нелинейные сценарии","aeroflot":"Аэрофлот","rooms_arrows":"Комнаты стрелками","rooms_jumps":"Комнаты прыжками","rr_distributor":"Русская рулетка с распределителем","rr_vars":"Русская рулетка с прыжками","math_problem":"Генератор задач"}}},"block":{"id":"Номер","title":"Комментарий","comment":"Комментарий","container_source":"Выход из страницы","container_target":"Вход в страницу","scope":{"label":"Область действия","for_one":"На игрока","for_team":"На команду","for_all":"На всех"}},"domain":{"new":"Новый домен","tool":"Домен","name":"Название","main_host":"Главный хост","hint":"Изолированная среда для одного заказчика"},"host":{"tool":"Хост","name":"Имя","make_main_host":"Сделать основным","hint":"Доменное имя вашего домена"},"game":{"name":"Название","guest_access":"Гостевой доступ","example":"Сценарий открыт","tool":"Сценарий","new":"Новый сценарий"},"first_task":{"new":"Первая страница"},"task":{"name":"Название","tool":"Страница","new":"Новая страница","hint":"Страница/задание/локация. Блок-контейнер. Может быть дано пользователю и завершено. Кликните дважды, чтобы посмотреть внутри.","show_wrong_answer":"Показывать 'Ответ неверен'","new_answer":"Добавить","expression":"Присвоить переменной","tp_source":"Точка выхода из страницы","input_type":{"label":"Тип ввода","text":"Текст","link":"Выбор","none":"Без поля ввода"}},"answer":{"tool":"Ответ","new":"Новый ответ","body":"Содержимое","reusable":{"label":"Можно вводить повторно","for_all":"Всем","for_other":"Остальным","not_reusable":"Запретить"},"spelling_matters":"Можно разные написания","hint":"Вариант ответа. Блок-инициатор. Генерирует сигнал при подходящем ответе.","link":"Ссылка"},"hint":{"tool":"Текст","body":"Содержимое","new":"Текст страницы","hint":"Текст страницы. При сигнале показывает текст на странице."},"message":{"tool":"Сообщение","message":"Текст сообщения","message_type":{"label":"Цвет сообщения","success":"Зеленый","info":"Синий","alert":"Желтый","error":"Красный"},"new":"Текст сообщения","hint":"Сообщение. При поступлении сигнала, выводит сообщение пользователю."},"timer":{"tool":"Таймер","hint":"Таймер. При поступлении сигнала передает его дальше через указанное время.","time":"Время"},"clock":{"tool":"Часы","hint":"Часы. Блок-инициатор. Передает сигнал в указанное время.","time":"Время"},"setter":{"tool":"Присвоить","hint":"Присвоить. При поступлении сигнала на вход, присваивает значение переменной (напр. x=rand(12)-y*2).","expression":"Выражение"},"checker":{"tool":"Триггер","hint":"Триггер. Блок-инициатор. Срабатывает при изменении любой переменной выражения и передает сигнал, если вычисленное выражение истинно. (напр. x>=20)","expression":"Выражение"},"condition":{"tool":"Условие","hint":"Условие. Передает сигнал, если вычисленное выражение истинно. (напр. x>=20)","expression":"Выражение"},"else_block":{"tool":"Иначе","hint":"Иначе. Передает сигнал, если не сработало ни одно условие выше него."},"distributor":{"tool":"Распределитель","hint":"Распределитель. Передает сигнал согласно выбранному алгоритму (случайно/динамически)."},"redirect_block":{"tool":"Редирект","hint":"Перенаправляет пользователя на указанный URL. (напр. http://google.com/)","url":"URL"},"request_block":{"tool":"Запрос","hint":"Совершает запрос с сервера по указанному адресу. Можно использовать переменные. (напр. http://google.com/?q=&#123;&#123;var&#125;&#125;)","url":"URL"},"and_block":{"tool":"И","new":"И","hint":"Блок И. Передает сигнал, если поступили сигналы со всех стрелок."},"or_block":{"tool":"ИЛИ","new":"ИЛИ","hint":"Блок ИЛИ. Передает сигнал при поступлении сигнала. Хаха, дурацкий блок :)"},"jump":{"new":"Прыжок","tool":"Прыжок","hint":"Прыжок. Передает сигнал на указанную контрольную точку. См. Контрольная точка.","checkpoint":"Контрольная точка"},"checkpoint":{"new":"Контрольная точка","tool":"Контрольная точка","hint":"Контрольная точка. Срабатывает при срабатывании прыжка в данную контрольную точку. См. Прыжок.","name":"Название"},"task_given":{"new":"Показать","tool":"Показать","hint":"Задание дано. Срабатывает, когда страница дана. Выдает текст страницы."},"task_passed":{"new":"Выход","tool":"Выход","hint":"Страница завершена. При поступлении сигнала страница считается завершенной.","message":"Задание выполнено! Следующее задание:"},"game_started":{"new":"Начат","tool":"Начат","hint":"Сценарий начат. В заданное время сценарий будет считаться начатым."},"game_passed":{"new":"Пройден","tool":"Пройден","hint":"Сценарий пройден. При поступлении сигнала на вход, сценарий будет считаться пройденным."},"properties":{"confirm_exit":"Изменения выделенного блока не были сохранены. Чтобы сохранить изменения, снимите с него выделение."},"domains":{"index":"Домены","new":"Новый домен","edit":"Изменить домен"},"hosts":{"index":"Хосты","add":"Добавить хост"},"games":{"index":"Игры","new":"Новый сценарий","edit":"Изменить сценарий"},"guides":{"buttons":{"prev":"Назад","next":"Далее","close":"Закрыть","next_guide":"Следующий гид","try":"Попробовать"},"overview":{"welcome":{"title":"Добро пожаловать!","description":"Вы сейчас находитесь в конструкторе Interactiff. Этот гид поможет вам ориентироваться в интерфейсе для самостоятельного создания сценариев. Для продолжения - нажмите \"Далее\"."},"header":{"title":"Верхняя панель","description":"Отсюда вы можете перейти в управление сценарием, а также выйти из задания для просмотра общего вида."},"reload":{"title":"Кнопка \"Обновить\"","description":"С помощью данной кнопки вы можете загрузить последнюю версию сценария с сервера."},"toolbar":{"title":"Панель инструментов","description":"Здесь расположен набор инструментов - строительные блоки для построения сценариев."},"tool":{"title":"Создать блок","description":"Для создания блока достаточно кликнуть на инструмент. При наведении на инструмент, можете увидеть подсказку к нему."},"field":{"title":"Поле","description":"Это - поле. Здесь располагаются созданные вами блоки и связи между ними, которые означают ход событий в рамках квеста."},"block":{"title":"Блок на поле","description":"Вы можете выбрать любой из них для редактирования, кликнув на него левой кнопкой мыши."},"properties":{"title":"Свойства","description":"Когда вы выбрали блок на поле, здесь отображаются его свойства. Вы можете изменить название задания, его текст, время начала игры или любые другие свойства блоков."}},"basic":{"welcome":{"title":"Создаем сценарий","description":"Давайте попробуем создать простой линейный сценарий из 1 страницы"},"create_task":{"title":"Новое задание","description":"Нажмите кнопку создания задания на панели инструментов."},"start_task":{"title":"Первая связь","description":"Отлично! Теперь свяжите начало квеста с нашим первым заданием. Для этого перетащите точку из начала игры на начало задания."},"finish_task":{"title":"Окончание квеста","description":"А завершение этого задания давайте привяжем к окончанию квеста. Всего одно задание, но мы ведь только учимся!"},"select_task":{"title":"Выберите задание","description":"Хорошо! Теперь давайте выберем созданное задание на поле и попробуем его отредактировать. Кликине на него."},"task_name":{"title":"Название задания","description":"Мы видим, что панель свойств сейчас содержит выбранное задание. Давайте укажем название задания, например \"Математическая задача\". Это название будет указано в заголовке во время прохождения. Затем нажмите кнопку \"Сохранить\"."},"enter_task":{"title":"Вход в задание","description":"Хорошо. Войдите в задание. Для этого дважды кликните по нему на поле."},"toolbar":{"title":"Возможные события","description":"Вы можете видеть, что панель инструментов изменилась, так как мы находимся внутри задания. Каждый блок - это определенное событие, которое может произойти в квесте."},"select_tg":{"title":"Выберите начало задания","description":"Измените текст при выдаче задания - выберите блок \"Задание дано\"."},"tg_body":{"title":"Измените текст","description":"Отредактируйте текст задания (например, \"Чему равно 5+12?\"). Сохраните блок для продолжения."},"select_field":{"title":"Выберите задание","description":"Давайте сделаем наше задание с вариантами выбора. Кликните на свободном месте на поле, чтобы выбрать задание, в котором мы сейчас находимся."},"set_choice":{"title":"Тип ввода - Выбор","description":"Измените свойство \"Тип ввода\" на \"Выбор\". Сохраните задание."},"create_answers":{"title":"Создайте варианты ответов","description":"Вы отлично справляетесь! Создайте 3 варианта ответа."},"right_answer":{"title":"Свяжите верный ответ","description":"Задайте тело каждого ответа, после чего cвяжите правильный ответ с \"Задание выполнено\""},"get_back":{"title":"Вернемся к общему виду","description":"Теперь давайте выйдем из задания в общую схему квеста."},"delete_block":{"title":"Удалите блок","description":"Ой, я случайно создал тут лишний блок И... он нам не нужен, давайте удалим его. Наведите на блок и нажмите крестик в углу."},"delete_relation":{"title":"Удаление связи","description":"А чтобы удалить связь - просто кликните на нее левой кнопкой мыши. А сейчас нажмите \"Далее\""},"select_gs":{"title":"Начало квеста","description":"Давайте запустим сделанный нами квест. Для этого выберите начало квеста."},"launch_quest":{"title":"Запустите квест","description":"Поставьте время начала на вчерашний день и сохраните."},"try_quest":{"title":"Попробуем?","description":"Вы сделали свой первый квест! Теперь попробуйте, как он работает!"}},"nl_quests":null,"variables":null,"requests":null,"hot_keys":null}}},"en":{"admin":{"title":"Builder","links":{"save":"Save","destroy":"Delete","sure":"Are you sure?","reset":"Reset events before testing?"},"path":{"root":"My quests","level_up":"&larr;&nbsp;&nbsp;General view","reload":"<span class=\"carrow\">&#8635</span> Refresh"},"help":{"link":"Help","options":{"overview":"Overview","basic":"Basic usage","nl_quests":"Nonlinear scenarios","variables":"Variables","hot_keys":"Hot keys","documentation":"Documentation","examples":"Examples","examples_menu":{"variables":"Variables","nl_quests":"Nonlinear scenarios","aeroflot":"Aeroflot","rooms_arrows":"Rooms with arrows","rooms_jumps":"Rooms with jumps","rr_distributor":"Russian roulette with distributor","rr_vars":"Russian roulette with jumps","math_problem":"Math problem generator"}}},"block":{"id":"Number","title":"Comment","comment":"Comment","container_source":"Exit point","container_target":"Enter point","scope":{"label":"Scope","for_one":"One player","for_team":"Team","for_all":"Everybody"}},"domain":{"new":"New domain","tool":"Domain","name":"Name","main_host":"Main host","hint":"Isolated environment for one customer"},"host":{"tool":"Host","name":"Name","make_main_host":"Make main host","hint":"Domain name"},"game":{"name":"Name","guest_access":"Guest access","example":"Open scenario","tool":"Scenario","new":"New scenario"},"first_task":{"name":"First page"},"task":{"name":"Name","tool":"Page","new":"New page","hint":"Task or location. Container block. May be given to user and finished. Double click to look inside.","show_wrong_answer":"Show 'Answer is incorrect'","new_answer":"Add","expression":"Assign to var","tp_source":"Page leave point","input_type":{"label":"Input type","text":"Text","link":"Selection","none":"None"}},"answer":{"tool":"Answer","new":"New answer","body":"Body","reusable":{"label":"Reusability","for_all":"For everyone","for_other":"For others","not_reusable":"Not reusable"},"spelling_matters":"Different spelling is allowed","hint":"Answer. Initiating block. Generates the signal if answer is correct.","link":"Link"},"hint":{"tool":"Text","body":"Body","new":"Page content","hint":"Page content. Shows text when receives the signal."},"message":{"tool":"Message","message":"Message","message_type":{"label":"Message color","success":"Green","info":"Blue","alert":"Yellow","error":"Red"},"new":"Message","hint":"Message. Shows message when receives a signal."},"timer":{"tool":"Timer","hint":"Timer. Initiating block. Delays a signal for specified time.","time":"Time"},"clock":{"tool":"Clock","hint":"Clock. Initiating block. Transmits the signal when specified time comes.","time":"Time"},"setter":{"tool":"Assign","hint":"Assign. Assigns a value to a variable when receives the signal. (i.e. x=rand(12)-y*2).","expression":"Expression"},"checker":{"tool":"Trigger","hint":"Trigger. Initiating block. Activates when a variable is changed and transmits the signal if expression is true. (i.e. x>=20)","expression":"Expression"},"condition":{"tool":"Condition","hint":"Condition. Transmits the signal if expression is true. (i.e. x>=20)","expression":"Expression"},"else_block":{"tool":"Else","hint":"Else. Transmits the signal if none of conditions above are fired."},"distributor":{"tool":"Distributor","hint":"Distributor. Transmits the signal due to chosen algorythm (random/dynamic)."},"redirect_block":{"tool":"Redirect","hint":"Redirects user to specified URL. (i.e http://google.com/)","url":"URL"},"request_block":{"tool":"Request","hint":"Makes a server request at specified adress. Variables are allowed. (i.e. http://google.com/?q=&#123;&#123;var&#125;&#125;)","url":"URL"},"and_block":{"tool":"AND","new":"AND","hint":"AND block. Transmits the signal if received the signal from all of the arrows."},"or_block":{"tool":"OR","new":"OR","hint":"OR block. Transmits the signal if received one. Haha, stupid block! :)"},"jump":{"new":"Jump to","tool":"Jump to","hint":"Jump to. Transmits the signal to a checkpoint. See Checkpoint.","checkpoint":"Checkpoint"},"checkpoint":{"new":"Checkpoint","tool":" Checkpoint","hint":" Checkpoint. Activates if signal jumps to a checkpoint. See Jump to","name":"Name"},"task_given":{"new":"Show","tool":"Show","hint":"Page is shown. Activates if page is shown. Shows page description."},"task_passed":{"new":"Exit","tool":"Exit","hint":"Page is closed. Makes page closed when receives the signal.","message":"Task is accomplished! Next task:"},"game_started":{"new":"Started","tool":"Started","hint":"Scenario is started. Scenario will start at specified time."},"game_passed":{"new":"Completed","tool":" Completed ","hint":"Scenario is completed. Makes scenario completed when receives the signal."},"properties":{"confirm_exit":"Changes were not saved. Remove the highlighting to save."},"guides":{"buttons":{"prev":"Back","next":"Next","close":"Close","next_guide":"Next guide","try":"Try"},"overview":{"welcome":{"title":"Welcome!","description":"This is Interactiff construction tool. This quide is designed to teach you the basics of quests creating. Click “Next” to continue.'"},"header":{"title":"Upper pannel","description":"This panel lets you proceed to the quest management screen or to close current task to quit to the common view"},"reload":{"title":"“Refresh” button","description":"Use this button to refresh your quest to the latest version."},"toolbar":{"title":"toolbar","description":"Here is the toolbar. You can see construction blocks for creating your quest."},"tool":{"title":"Create a block","description":"Click any tool to create a block. Mouse over an instrument to display a tip."},"field":{"title":"Workspace","description":"This is a workspace. It is a place for your blocks and connections, which will define your quest progress."},"block":{"title":"Block in the workspace","description":"Left-click to select a block for editing."},"properties":{"title":"Properties","description":"Here are the properties of the block you’ve selected. You can edit the title of a task, type your text, set your quest starting time and edit other properties."}},"basic":{"welcome":{"title":"Creating a quest","description":"Let’s try to create a simple linear quest with one task"},"create_task":{"title":"New task","description":"Click the “New Task” button on the toolbar."},"start_task":{"title":"First connection","description":"Perfect! Let’s tie the “Started” with our new task. Just drag that black dot to the task block."},"finish_task":{"title":"Finish","description":"Now let’s tie our task with “Completed”. Yes, there is just one task. We are still learning!"},"select_task":{"title":"Select a task","description":"Great! Let’s select our task for editing. Just click it."},"task_name":{"title":"Task title","description":"We can see properties of the selected task. Let’s name it! Try \"Mathematical problem\" or anything you want. Your player will see it as a task title during playing the quest. Click \"Save\" button."},"enter_task":{"title":"Enter the task","description":"Good. Now let’s enter the text. Just double-click the block."},"toolbar":{"title":"Events","description":"As you see, toolbar looks different inside the task. Every block here is an event which can occur during your quest."},"select_tg":{"title":"Select the “Given”","description":"Set the text that will be displayed in the beginning - select \"Given\" block."},"tg_body":{"title":"Edit the text","description":"Edit the text of our task(try, \"What is 5+12?\" or anything you want). Save changes to continue."},"select_field":{"title":"Select your task","description":"Let’s make it with several choices. Click in the background to select the current task."},"set_choice":{"title":"Input type - Selection","description":"Change \"Input type\" property to \"Selection\". Save your task."},"create_answers":{"title":"Creating answer options","description":"You are doing great! Create 3 answers."},"right_answer":{"title":"Right answer","description":"Set the body of the answers, and tie the correct one with \"Accomplished\""},"get_back":{"title":"Proceed to the common view","description":"Let’s quit the task and proceed to our quest’s common view."},"delete_block":{"title":"Delete the block","description":"Oops, I’ve created the “AND” block… We don’t need it, let’s delete it. Mouse over the block and click at the x in the upper right corner."},"delete_relation":{"title":"Delete the connection","description":"Just click on the connection to delete it. Now click \"Next\""},"select_gs":{"title":"Launching the quest","description":"Let’s launch our quest. Select the “Started” block."},"launch_quest":{"title":"Launching the quest","description":"Set yesterday as starting time and save the changes."},"try_quest":{"title":"Let’s give it a try?","description":"You’ve just created your first quest! Let’s play it!"}},"nl_quests":null,"variables":null,"requests":null,"hot_keys":null}}},"zh-TW":{"admin":{"item":{"view_live_html":"查看此新聞 <br/><em>(在新視窗打開)</em>","edit":"編輯此新聞","delete":"永遠删除此新聞","published":"已發佈"},"index":{"actions":"動作","create":"新增新聞","item":"新聞","no_items":"對不起，找不到資料.","no_items_yet":"目前沒有新聞. 點選 \"新增新聞\" 來新增你的第一條新聞."}}}};