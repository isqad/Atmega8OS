Atmega8OS
=========

Простейшая операционная система для микроконтроллера Atmega8. Из особенностей:

* Позволяет делить на подзадачи
* Очередь задач
* Планировщик выбирает задачу на выполнение по прерыванию таймера каждую 1 мс (задается вручную в os.asm в TimerDivider)
* Приоритетов задач нет