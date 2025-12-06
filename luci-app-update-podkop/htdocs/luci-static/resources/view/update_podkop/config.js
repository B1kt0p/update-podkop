'use strict';
'require view';
'require form';
'require uci';
'require fs';
'require ui';

return view.extend({
    load: function() {
        return uci.load('update-podkop');
    },

    render: function(data) {
        var m, s, o;

        m = new form.Map('update-podkop', _('Update Podkop'),
            _('Настройка параметров для update-podkop'));

        // Основная секция настроек
        s = m.section(form.NamedSection, 'settings', 'settings', _('Settings'));
        s.anonymous = false;
        s.addremove = false;

        o = s.option(form.Value, 'url', _('URL'),
            _('URL сервера для обновлений'));
        o.rmempty = false;
        o.placeholder = 'https://example.com/api';

        o = s.option(form.Value, 'token', _('Token'),
            _('Токен авторизации'));
        o.password = true;
        o.rmempty = false;

        // Секция действий
        s = m.section(form.NamedSection, '_run', 'run', _('Actions'));
        s.anonymous = true;

        o = s.option(form.Button, '_run');
        o.inputtitle = _('Запустить update-podkop');
        o.inputstyle = 'apply';
        o.onclick = function(ev) {
            var btn = ev.target;
            btn.disabled = true;
            btn.value = _('Выполняется...');

            return fs.exec('/usr/bin/update-podkop')
                .then(function(res) {
                    var output = (res.stdout || '') + (res.stderr || '');
                    
                    if (res.code === 0) {
                        ui.addNotification(null, 
                            E('p', _('Команда выполнена успешно')), 
                            'info');
                    } else {
                        ui.addNotification(null, 
                            E('p', _('Ошибка выполнения (код: %d)').format(res.code)), 
                            'error');
                    }

                    if (output.trim()) {
                        ui.showModal(_('Результат выполнения'), [
                            E('pre', { 
                                'style': 'max-height: 400px; overflow: auto; background: #f5f5f5; padding: 10px;' 
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
                        E('p', _('Ошибка: %s').format(err.message)), 
                        'error');
                })
                .finally(function() {
                    btn.disabled = false;
                    btn.value = _('Запустить update-podkop');
                });
        };

        return m.render();
    },

    handleSaveApply: null,
    handleSave: null,
    handleReset: null
});