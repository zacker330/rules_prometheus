{
  'config1.json': {
    global: {
      smtp_smarthost: 'localhost:25',
      smtp_from: 'alertmanager@example.org',
      smtp_auth_username: 'alertmanager',
      smtp_auth_password: 'password',
    },
    templates: [
      '/etc/alertmanager/template/*.tmpl',
    ],
    route: {
      group_by: [
        'alertname',
        'cluster',
        'service',
      ],
      group_wait: '30s',
      group_interval: '5m',
      repeat_interval: '3h',
      receiver: 'team-X-mails',
      routes: [
        {
          matchers: [
            'service=~"foo1|foo2|baz"',
          ],
          receiver: 'team-X-mails',
          routes: [
            {
              matchers: [
                'severity="critical"',
              ],
              receiver: 'team-X-pager',
            },
          ],
        },
        {
          matchers: [
            'service="files"',
          ],
          receiver: 'team-Y-mails',
          routes: [
            {
              matchers: [
                'severity="critical"',
              ],
              receiver: 'team-Y-pager',
            },
          ],
        },
        {
          matchers: [
            'service="database"',
          ],
          receiver: 'team-DB-pager',
          group_by: [
            'alertname',
            'cluster',
            'database',
          ],
          routes: [
            {
              matchers: [
                'owner="team-X"',
              ],
              receiver: 'team-X-pager',
              continue: true,
            },
            {
              matchers: [
                'owner="team-Y"',
              ],
              receiver: 'team-Y-pager',
            },
          ],
        },
      ],
    },
    inhibit_rules: [
      {
        source_matchers: [
          'severity="critical"',
        ],
        target_matchers: [
          'severity="warning"',
        ],
        equal: [
          'alertname',
          'cluster',
          'service',
        ],
      },
    ],
    receivers: [
      {
        name: 'team-X-mails',
        email_configs: [
          {
            to: 'team-X+alerts@example.org',
          },
        ],
      },
      {
        name: 'team-X-pager',
        email_configs: [
          {
            to: 'team-X+alerts-critical@example.org',
          },
        ],
        pagerduty_configs: [
          {
            service_key: '<team-X-key>',
          },
        ],
      },
      {
        name: 'team-Y-mails',
        email_configs: [
          {
            to: 'team-Y+alerts@example.org',
          },
        ],
      },
      {
        name: 'team-Y-pager',
        pagerduty_configs: [
          {
            service_key: '<team-Y-key>',
          },
        ],
      },
      {
        name: 'team-DB-pager',
        pagerduty_configs: [
          {
            service_key: '<team-DB-key>',
          },
        ],
      },
    ],
  },
  'config2.json': {
    global: {
      smtp_smarthost: 'localhost:25',
      smtp_from: 'alertmanager@example.org',
      smtp_auth_username: 'alertmanager',
      smtp_auth_password: 'password',
    },
    templates: [
      '/etc/alertmanager/template/*.tmpl',
    ],
    route: {
      group_by: [
        'alertname',
        'cluster',
        'service',
      ],
      group_wait: '30s',
      group_interval: '5m',
      repeat_interval: '3h',
      receiver: 'team-X-mails',
      routes: [
        {
          matchers: [
            'service=~"foo1|foo2|baz"',
          ],
          receiver: 'team-X-mails',
          routes: [
            {
              matchers: [
                'severity="critical"',
              ],
              receiver: 'team-X-pager',
            },
          ],
        },
        {
          matchers: [
            'service="files"',
          ],
          receiver: 'team-Y-mails',
          routes: [
            {
              matchers: [
                'severity="critical"',
              ],
              receiver: 'team-Y-pager',
            },
          ],
        },
        {
          matchers: [
            'service="database"',
          ],
          receiver: 'team-DB-pager',
          group_by: [
            'alertname',
            'cluster',
            'database',
          ],
          routes: [
            {
              matchers: [
                'owner="team-X"',
              ],
              receiver: 'team-X-pager',
              continue: true,
            },
            {
              matchers: [
                'owner="team-Y"',
              ],
              receiver: 'team-Y-pager',
            },
          ],
        },
      ],
    },
    inhibit_rules: [
      {
        source_matchers: [
          'severity="critical"',
        ],
        target_matchers: [
          'severity="warning"',
        ],
        equal: [
          'alertname',
          'cluster',
          'service',
        ],
      },
    ],
    receivers: [
      {
        name: 'team-X-mails',
        email_configs: [
          {
            to: 'team-X+alerts@example.org',
          },
        ],
      },
      {
        name: 'team-X-pager',
        email_configs: [
          {
            to: 'team-X+alerts-critical@example.org',
          },
        ],
        pagerduty_configs: [
          {
            service_key: '<team-X-key>',
          },
        ],
      },
      {
        name: 'team-Y-mails',
        email_configs: [
          {
            to: 'team-Y+alerts@example.org',
          },
        ],
      },
      {
        name: 'team-Y-pager',
        pagerduty_configs: [
          {
            service_key: '<team-Y-key>',
          },
        ],
      },
      {
        name: 'team-DB-pager',
        pagerduty_configs: [
          {
            service_key: '<team-DB-key>',
          },
        ],
      },
    ],
  },
}
