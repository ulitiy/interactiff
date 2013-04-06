var I18n = I18n || {};
I18n.translations = {"ru":{"admin":{"links":{"save":"Сохранить","destroy":"Удалить","sure":"Вы уверены?"},"path":{"root":"Мои квесты","level_up":"&larr; Назад","reload":"<span class=\"carrow\">&#8635</span> Обновить"},"block":{"id":"Номер","title":"Комментарий","comment":"Комментарий","container_source":"Пуговка выход","container_target":"Пуговка вход","scope":{"label":"Область действия","for_one":"На игрока","for_team":"На команду","for_all":"На всех"}},"domain":{"new":"Новый домен","tool":"Домен","name":"Название","main_host":"Главный хост","hint":"Изолированная среда для одного заказчика"},"host":{"tool":"Хост","name":"Имя","make_main_host":"Сделать основным","hint":"Доменное имя вашего домена"},"game":{"name":"Название","guest_access":"Гостевой доступ","tool":"Сценарий","new":"Новый сценарий"},"task":{"name":"Название","tool":"Задание","new":"Новое задание","hint":"Задание/локация. Блок-контейнер. Может быть дано пользователю и завершено. Кликните дважды, чтобы посмотреть внутри.","input_type":{"label":"Тип ввода","text":"Текст","link":"Выбор","none":"Без поля ввода"}},"answer":{"tool":"Ответ","new":"Ответ","body":"Содержимое","reusable":{"label":"Можно вводить повторно","for_all":"Всем","for_other":"Остальным","not_reusable":"Запретить"},"spelling_matters":"Можно разные написания","hint":"Вариант ответа. Блок-инициатор. Генерирует сигнал при подходящем ответе.","link":"Ссылка"},"hint":{"tool":"Текст","body":"Содержимое","new":"Текст задания","hint":"Текст задания. При сигнале показывает текст в задании."},"message":{"tool":"Сообщение","message":"Текст сообщения","message_type":{"label":"Цвет сообщения","success":"Зеленый","info":"Синий","alert":"Желтый","error":"Красный"},"new":"Текст сообщения","hint":"Сообщение. При поступлении сигнала, выводит сообщение пользователю."},"timer":{"tool":"Таймер","hint":"Таймер. Блок-инициатор. При поступлении сигнала передает его дальше через указанное время.","time":"Время"},"clock":{"tool":"Часы","hint":"Часы. Блок-инициатор. Передает сигнал в указанное время.","time":"Время"},"setter":{"tool":"Присвоить","hint":"Присвоить. При поступлении сигнала на вход, присваивает значение переменной (напр. x=rand(12)-y*2).","expression":"Выражение"},"checker":{"tool":"Триггер","hint":"Триггер. Блок-инициатор. Срабатывает при изменении любой переменной выражения и передает сигнал, если вычисленное выражение истинно. (напр. x>=20)","expression":"Выражение"},"condition":{"tool":"Условие","hint":"Условие. Передает сигнал, если вычисленное выражение истинно. (напр. x>=20)","expression":"Выражение"},"distributor":{"tool":"Распределитель","hint":"Распределитель. Передает сигнал согласно выбранному алгоритму (случайно/динамически)."},"redirect_block":{"tool":"Редирект","hint":"Перенаправляет пользователя на указанный URL. (напр. http://google.com/)","url":"URL"},"request_block":{"tool":"Запрос","hint":"Совершает запрос с сервера по указанному адресу. Можно использовать переменные. (напр. http://google.com/?q=&#123;&#123;var&#125;&#125;)","url":"URL"},"and_block":{"tool":"И","new":"И","hint":"Блок И. Передает сигнал, если поступили сигналы со всех стрелок."},"or_block":{"tool":"ИЛИ","new":"ИЛИ","hint":"Блок ИЛИ. Передает сигнал при поступлении сигнала. Хаха, дурацкий блок :)"},"jump":{"new":"Прыжок","tool":"Прыжок","hint":"Прыжок. Передает сигнал на указанную контрольную точку. См. Контрольная точка.","checkpoint":"Контрольная точка"},"checkpoint":{"new":"Контрольная точка","tool":"Контрольная точка","hint":"Контрольная точка. Срабатывает при срабатывании прыжка в данную контрольную точку. См. Прыжок.","name":"Название"},"task_given":{"new":"Дано","tool":"Дано","hint":"Задание дано. Срабатывает, когда задание дано. Выдает текст задания."},"task_passed":{"new":"Выполнено","tool":"Выполнено","hint":"Задание выполнено. При поступлении сигнала задание считается завершенным.","message":"Задание выполнено! Следующее задание:"},"game_started":{"new":"Начат","tool":"Начат","hint":"Сценарий начат. В заданное время сценарий будет считаться начатым."},"game_passed":{"new":"Пройден","tool":"Пройден","hint":"Сценарий пройден. При поступлении сигнала на вход, сценарий будет считаться пройденным."},"properties":{"confirm_exit":"Изменения выделенного блока не были сохранены. Чтобы сохранить изменения, снимите с него выделение."},"domains":{"index":"Домены","new":"Новый домен","edit":"Изменить домен"},"hosts":{"index":"Хосты","add":"Добавить хост"},"games":{"index":"Игры","new":"Новый квест","edit":"Изменить квест"},"tasks":{"index":"Задания","add":"Добавить задание","edit":"Изменить задание"}}},"zh-TW":{"admin":{"item":{"view_live_html":"查看此新聞 <br/><em>(在新視窗打開)</em>","edit":"編輯此新聞","delete":"永遠删除此新聞","published":"已發佈"},"index":{"actions":"動作","create":"新增新聞","item":"新聞","no_items":"對不起，找不到資料.","no_items_yet":"目前沒有新聞. 點選 \"新增新聞\" 來新增你的第一條新聞."}}}};