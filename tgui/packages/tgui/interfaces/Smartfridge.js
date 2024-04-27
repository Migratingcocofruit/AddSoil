import { useBackend } from '../backend';
import {
  Box,
  Section,
  Button,
  NumberInput,
  Stack,
  NoticeBox,
  Icon,
} from '../components';
import { Window } from '../layouts';

export const Smartfridge = (props, context) => {
  const { act, data } = useBackend(context);
  const { disk_storage } = data;
  return (
    <Window width={500} height={500}>
      <Window.Content>
        {disk_storage ? <Diskstorage /> : <Fridge />}
      </Window.Content>
    </Window>
  );
};

const Fridge = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    secure, // secure fridge notice
    can_dry, // dry section
    drying, // drying rack on/off.
    contents,
  } = data;
  return (
    <Stack fill vertical>
      {!!secure && (
        <NoticeBox>
          Secure Access: Please have your identification ready.
        </NoticeBox>
      )}
      <Section
        fill
        scrollable
        title={can_dry ? 'Drying rack' : 'Contents'}
        buttons={
          !!can_dry && (
            <Button
              width={4}
              icon={drying ? 'power-off' : 'times'}
              content={drying ? 'On' : 'Off'}
              selected={drying}
              onClick={() => act('drying')}
            />
          )
        }
      >
        {!contents && (
          <Stack fill>
            <Stack.Item
              bold
              grow
              textAlign="center"
              align="center"
              color="average"
            >
              <Icon.Stack>
                <Icon name="cookie-bite" size={5} color="brown" />
                <Icon name="slash" size={5} color="red" />
              </Icon.Stack>
              <br />
              No products loaded.
            </Stack.Item>
          </Stack>
        )}
        {!!contents &&
          contents
            .slice()
            .sort((a, b) => a.display_name.localeCompare(b.display_name))
            .map((item) => {
              return (
                <Stack key={item}>
                  <Stack.Item width="55%">{item.display_name}</Stack.Item>
                  <Stack.Item width="25%">
                    ({item.quantity} in stock)
                  </Stack.Item>
                  <Stack.Item width={13}>
                    <Button
                      width={3}
                      icon="arrow-down"
                      tooltip="Dispense one."
                      content="1"
                      onClick={() =>
                        act('vend', { index: item.vend, amount: 1 })
                      }
                    />
                    <NumberInput
                      width="40px"
                      minValue={0}
                      value={0}
                      maxValue={item.quantity}
                      step={1}
                      stepPixelSize={3}
                      onChange={(e, value) =>
                        act('vend', { index: item.vend, amount: value })
                      }
                    />
                    <Button
                      width={4}
                      icon="arrow-down"
                      content="All"
                      tooltip="Dispense all."
                      tooltipPosition="bottom-start"
                      onClick={() =>
                        act('vend', {
                          index: item.vend,
                          amount: item.quantity,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              );
            })}
      </Section>
    </Stack>
  );
};

const Diskstorage = (props, context) => {
  const { act, data } = useBackend(context);
  const { empty_disks, stat_disks, trait_disks, reagent_disks } = data;
  return (
    <Stack fill vertical>
      <Section
        fill
        title={'Disk Compartmentalizer'}
        height={20}
        buttons={
          <Button
            width={16}
            content={'Vend Empty Disk ' + empty_disks + ' Remaining'}
            onClick={() => act('vend_empty')}
          />
        }
      />
      <Section fill scrollable title={'Stat Disks'}>
        {!stat_disks && (
          <Stack fill>
            <Stack.Item
              bold
              grow
              textAlign="center"
              align="center"
              color="average"
            >
              <Icon.Stack>
                <Icon name="cookie-bite" size={5} color="brown" />
                <Icon name="slash" size={5} color="red" />
              </Icon.Stack>
              <br />
              No products loaded.
            </Stack.Item>
          </Stack>
        )}
        {!!stat_disks &&
          stat_disks
            .slice()
            .sort((a, b) => a.display_name.localeCompare(b.display_name))
            .map((item) => {
              return (
                <Stack key={item}>
                  <Stack.Item width="55%">{item.display_name}</Stack.Item>
                  <Stack.Item width="25%">
                    ({item.quantity} in stock)
                  </Stack.Item>
                  <Stack.Item width={13}>
                    <Button
                      width={3}
                      icon="arrow-down"
                      tooltip="Dispense one."
                      content="1"
                      onClick={() =>
                        act('vend', { index: item.vend, amount: 1 })
                      }
                    />
                    <NumberInput
                      width="40px"
                      minValue={0}
                      value={0}
                      maxValue={item.quantity}
                      step={1}
                      stepPixelSize={3}
                      onChange={(e, value) =>
                        act('vend', { index: item.vend, amount: value })
                      }
                    />
                    <Button
                      width={4}
                      icon="arrow-down"
                      content="All"
                      tooltip="Dispense all."
                      tooltipPosition="bottom-start"
                      onClick={() =>
                        act('vend', {
                          index: item.vend,
                          amount: item.quantity,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              );
            })}
      </Section>
      <Section fill scrollable title={'Trait Disks'}>
        {!trait_disks && (
          <Stack fill>
            <Stack.Item
              bold
              grow
              textAlign="center"
              align="center"
              color="average"
            >
              <Icon.Stack>
                <Icon name="cookie-bite" size={5} color="brown" />
                <Icon name="slash" size={5} color="red" />
              </Icon.Stack>
              <br />
              No products loaded.
            </Stack.Item>
          </Stack>
        )}
        {!!trait_disks &&
          trait_disks
            .slice()
            .sort((a, b) => a.display_name.localeCompare(b.display_name))
            .map((item) => {
              return (
                <Stack key={item}>
                  <Stack.Item width="55%">{item.display_name}</Stack.Item>
                  <Stack.Item width="25%">
                    ({item.quantity} in stock)
                  </Stack.Item>
                  <Stack.Item width={13}>
                    <Button
                      width={3}
                      icon="arrow-down"
                      tooltip="Dispense one."
                      content="1"
                      onClick={() =>
                        act('vend', { index: item.vend, amount: 1 })
                      }
                    />
                    <NumberInput
                      width="40px"
                      minValue={0}
                      value={0}
                      maxValue={item.quantity}
                      step={1}
                      stepPixelSize={3}
                      onChange={(e, value) =>
                        act('vend', { index: item.vend, amount: value })
                      }
                    />
                    <Button
                      width={4}
                      icon="arrow-down"
                      content="All"
                      tooltip="Dispense all."
                      tooltipPosition="bottom-start"
                      onClick={() =>
                        act('vend', {
                          index: item.vend,
                          amount: item.quantity,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              );
            })}
      </Section>
      <Section fill scrollable title={'Reagent Disks'}>
        {!reagent_disks && (
          <Stack fill>
            <Stack.Item
              bold
              grow
              textAlign="center"
              align="center"
              color="average"
            >
              <Icon.Stack>
                <Icon name="cookie-bite" size={5} color="brown" />
                <Icon name="slash" size={5} color="red" />
              </Icon.Stack>
              <br />
              No products loaded.
            </Stack.Item>
          </Stack>
        )}
        {!!reagent_disks &&
          reagent_disks
            .slice()
            .sort((a, b) => a.display_name.localeCompare(b.display_name))
            .map((item) => {
              return (
                <Stack key={item}>
                  <Stack.Item width="55%">{item.display_name}</Stack.Item>
                  <Stack.Item width="25%">
                    ({item.quantity} in stock)
                  </Stack.Item>
                  <Stack.Item width={13}>
                    <Button
                      width={3}
                      icon="arrow-down"
                      tooltip="Dispense one."
                      content="1"
                      onClick={() =>
                        act('vend', { index: item.vend, amount: 1 })
                      }
                    />
                    <NumberInput
                      width="40px"
                      minValue={0}
                      value={0}
                      maxValue={item.quantity}
                      step={1}
                      stepPixelSize={3}
                      onChange={(e, value) =>
                        act('vend', { index: item.vend, amount: value })
                      }
                    />
                    <Button
                      width={4}
                      icon="arrow-down"
                      content="All"
                      tooltip="Dispense all."
                      tooltipPosition="bottom-start"
                      onClick={() =>
                        act('vend', {
                          index: item.vend,
                          amount: item.quantity,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              );
            })}
      </Section>
    </Stack>
  );
};
