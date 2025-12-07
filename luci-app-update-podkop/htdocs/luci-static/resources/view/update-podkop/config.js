'use strict';
'require view';
'require form';
'require fs';
'require ui';

return view.extend({
    load: function() {
        return Promise.resolve();
    },

    render: function() {
        var m, s, o;

        m = new form.Map('update-podkop', _('Update Podkop'),
            _('Настройка параметров для update-podkop'));

        // Секция настроек
        s = m.section(form.NamedSection, 'settings', 'settings', _('Настройки'));
        s.addremove = false;

        o = s.option(form.Value, 'url', _('URL'),
            _('URL сервера для обновлений'));
        o.placeholder = 'https://example.com/api';
        o.rmempty = false;

        o = s.option(form.Value, 'token', _('Token'),
            _('Токен авторизации'));
        o.password = true;
        o.rmempty = false;

        // Рендерим форму и добавляем кнопку вручную
        return m.render().then(function(mapNode) {
            // Создаём секцию с кнопкой
            var runSection = E('div', { 'class': 'cbi-section' }, [
                E('h3', {}, _('Запуск')),
                E('div', { 'class': 'cbi-section-descr' }, 
                    _('Запустить скрипт update-podkop')),
                E('div', { 'class': 'cbi-value' }, [
                    E('button', {
                        'class': 'cbi-button cbi-button-action important',
                        'click': function(ev) {
                            var btn = ev.target;
                            btn.disabled = true;
                            btn.textContent = _('Выполняется...');

                            fs.exec('/usr/bin/update-podkop')
                                .then(function(res) {
                                    var output = (res.stdout || '') + (res.stderr || '');
                                    
                                    if (res.code === 0) {
                                        ui.addNotification(null, 
                                            E('p', _('✓ Команда выполнена успешно!')), 
                                            'info');
                                    } else {
                                        ui.addNotification(null, 
                                            E('p', _('✗ Ошибка выполнения. Код: %d').format(res.code)), 
                                            'error');
                                    }

                                    if (output.trim()) {
                                        ui.showModal(_('Результат выполнения'), [
                                            E('pre', { 
                                                'style': 'max-height: 400px; overflow: auto; background: #f5f5f5; padding: 10px; border-radius: 4px; font-size: 12px;' 
                                            }, output),
                                            E('div', { 'class': 'right' }, [
                                                E('button', {
                                                    'class': 'btn cbi-button',
                                                    'click': ui.hideModal
                                                }, _('Закрыть'))
                                            ])
                                        ]);
                                    }
                                })
                                .catch(function(err) {
                                    ui.addNotification(null, 
                                        E('p', _('✗ Ошибка: %s').format(err.message)), 
                                        'error');
                                })
                                .finally(function() {
                                    btn.disabled = false;
                                    btn.textContent = _('Запустить update-podkop');
                                });
                        }
                    }, _('Запустить update-podkop'))
                ])
            ]);

            // Вставляем кнопку перед стандартными кнопками Save/Apply
            mapNode.insertBefore(runSection, mapNode.lastElementChild);
            
            return mapNode;
        });
    }
});